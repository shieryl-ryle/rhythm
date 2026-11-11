import '../data/enums.dart';
import 'models.dart';
import 'ranking.dart';

/// The plain-language reason shown with an option (BR-004). [code] is stored in `offer_reason.reason_code`.
class Reason {
  const Reason(this.code, this.text);

  final String code;
  final String text;

  @override
  String toString() => '$code: $text';
}

/// The reason on the card: the first of [chooseReasons].
Reason chooseReason({
  required ActionInfo action,
  required ScoreParts parts,
  required PersonContext person,
  required RankingRequest request,
  required Map<String, ActionInfo> byId,
}) =>
    chooseReasons(action: action, parts: parts, person: person, request: request, byId: byId).first;

/// EQ-004. Every reason that applies, strongest first: the first is the one on the card and the rest are what
/// "Why this?" adds (BR-004). A first-time action that is similar to one the person did and enjoyed always says so
/// first. Then each score term that applies, the one that adds the most first; a term counts only when it rests on
/// something the person actually did or said (a first-time action has no "You managed this before"). Then, when
/// they are true, lighter mode, company and starter. A neutral library line that claims nothing about the person
/// is used only when nothing else applies. A reason may only cite an answer a rule uses (BR-004).
List<Reason> chooseReasons({
  required ActionInfo action,
  required ScoreParts parts,
  required PersonContext person,
  required RankingRequest request,
  required Map<String, ActionInfo> byId,
}) {
  final reasons = <Reason>[];

  // New to them: say which action they enjoyed that this one is like.
  if (parts.known == 0) {
    final liked = _enjoyedActionIds(person);
    for (final id in action.similarTo) {
      if (liked.contains(id) && byId[id] != null) {
        reasons.add(Reason('similar', 'Similar to ${byId[id]!.title}, which you enjoyed'));
        break;
      }
    }
  }

  // Each candidate is a term with the amount it adds to the score. Ties keep this order.
  final terms = <(double, Reason)>[
    if (parts.done > 0) (0.5 * parts.fit, const Reason('fit', 'You managed this before')),
    if (parts.enjoyAnswers > 0 && parts.enjoy > 0)
      (0.3 * parts.enjoy, const Reason('enjoy', 'You said this felt good')),
    for (final o in parts.observations) (0.2, Reason('observation', o.text)),
    if (parts.saved) (0.2, const Reason('saved', 'You saved this')),
    if (parts.help == 'shorter_sessions')
      (0.1, const Reason('help_shorter', 'You said shorter sessions would help')),
    if (parts.help == 'someone_to_go_with') (0.1, const Reason('help_company', 'You said company would help')),
  ];
  // A stable sort, strongest first: a tie keeps the order above.
  final ordered = <(double, Reason)>[];
  for (final t in terms) {
    var at = ordered.length;
    while (at > 0 && ordered[at - 1].$1 < t.$1) {
      at--;
    }
    ordered.insert(at, t);
  }
  reasons.addAll([for (final t in ordered) t.$2]);

  if (request.lighter) reasons.add(const Reason('lighter', 'Short and gentle for today'));
  if (action.tags.contains('with_company') && person.motivations.contains('time_with_people')) {
    reasons.add(const Reason('company', 'You like company'));
  }
  // "A small way to begin" says nothing about someone who has already done it, so it is a reason only for a first time
  // (or when nothing else applies, as before).
  if (action.isStarter && (parts.known == 0 || reasons.isEmpty)) reasons.add(const Reason('starter', 'A small way to begin'));

  if (reasons.isEmpty) {
    // Neither line may overstate the action: "gentle" is not said of something that needs high energy.
    reasons.add(
      action.energyNeeded == Energy.high
          ? const Reason('neutral', 'Something different to try')
          : action.tags.contains('with_company')
              ? const Reason('neutral', 'Social and easy to learn')
              : const Reason('neutral', 'A gentle way to get moving'),
    );
  }
  return reasons;
}

/// Actions the person did and enjoyed (`completed` or `partly`, "Enjoyed it").
Set<String> _enjoyedActionIds(PersonContext person) => {
      for (final r in person.reflections)
        if (r.actionId != null &&
            (r.status == ReflectionStatus.completed || r.status == ReflectionStatus.partly) &&
            r.enjoyment == 3)
          r.actionId!,
    };
