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

/// EQ-004. A first-time action that is similar to one the person did and enjoyed always says so (BR-004,
/// F-002). Otherwise the score term that adds the most picks its template; a term counts only when it rests on
/// something the person actually did or said (a first-time action has no "You managed this before"). When no
/// term applies the order is: lighter mode, company, starter, and last a neutral library line that claims
/// nothing about the person. A reason may only cite an answer a rule uses (BR-004).
Reason chooseReason({
  required ActionInfo action,
  required ScoreParts parts,
  required PersonContext person,
  required RankingRequest request,
  required Map<String, ActionInfo> byId,
}) {
  // New to them: say which action they enjoyed that this one is like.
  if (parts.known == 0) {
    final liked = _enjoyedActionIds(person);
    for (final id in action.similarTo) {
      if (liked.contains(id) && byId[id] != null) {
        return Reason('similar', 'Similar to ${byId[id]!.title}, which you enjoyed');
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
  if (terms.isNotEmpty) {
    var best = terms.first;
    for (final t in terms.skip(1)) {
      if (t.$1 > best.$1) best = t;
    }
    return best.$2;
  }

  if (request.lighter) return const Reason('lighter', 'Short and gentle for today');
  if (action.tags.contains('with_company') && person.motivations.contains('time_with_people')) {
    return const Reason('company', 'You like company');
  }
  if (action.isStarter) return const Reason('starter', 'A small way to begin');
  // Neither line may overstate the action: "gentle" is not said of something that needs high energy.
  if (action.energyNeeded == Energy.high) return const Reason('neutral', 'Something different to try');
  return action.tags.contains('with_company')
      ? const Reason('neutral', 'Social and easy to learn')
      : const Reason('neutral', 'A gentle way to get moving');
}

/// Actions the person did and enjoyed (`completed` or `partly`, "Enjoyed it").
Set<String> _enjoyedActionIds(PersonContext person) => {
      for (final r in person.reflections)
        if (r.actionId != null &&
            (r.status == ReflectionStatus.completed || r.status == ReflectionStatus.partly) &&
            r.enjoyment == 3)
          r.actionId!,
    };
