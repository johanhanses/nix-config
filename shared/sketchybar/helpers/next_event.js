// Prints "<start epoch>\t<end epoch>\t<title>" for the next timed event that
// hasn't ended within 24h (skipping all-day and declined events), "none" if
// there is none, "noaccess" without Calendar permission.
ObjC.import('EventKit');

function run() {
  if ($.EKEventStore.authorizationStatusForEntityType($.EKEntityTypeEvent) != 3) return 'noaccess';
  const store = $.EKEventStore.alloc.init;
  const now = $.NSDate.date;
  const pred = store.predicateForEventsWithStartDateEndDateCalendars(
    now, $.NSDate.dateWithTimeIntervalSinceNow(24 * 3600),
    store.calendarsForEntityType($.EKEntityTypeEvent)); // JS null arrives as NSNull, not nil
  const evs = store.eventsMatchingPredicate(pred);
  const t = now.timeIntervalSince1970;
  let best = null;
  for (let i = 0; i < evs.count; i++) {
    const e = evs.objectAtIndex(i);
    if (e.allDay) continue;
    const s = e.startDate.timeIntervalSince1970, en = e.endDate.timeIntervalSince1970;
    if (en <= t) continue;
    const att = e.attendees;
    let declined = false;
    if (att && !att.isNil()) {
      for (let j = 0; j < att.count; j++) {
        const p = att.objectAtIndex(j);
        if (p.isCurrentUser && p.participantStatus == 3) declined = true; // EKParticipantStatusDeclined
      }
    }
    if (declined) continue;
    if (!best || s < best.s) best = { s, en, title: ObjC.unwrap(e.title) || '(no title)' };
  }
  if (!best) return 'none';
  return `${Math.round(best.s)}\t${Math.round(best.en)}\t${best.title.replace(/[\t\n]/g, ' ')}`;
}
