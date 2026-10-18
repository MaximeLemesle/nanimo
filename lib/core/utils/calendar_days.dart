/// Midnights crossed from [from] to [to], negative when [to] is earlier.
/// UTC keeps a daylight saving change from losing an hour, hence a day.
int calendarDaysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
