using CareBaby.Application.Common.Contracts.Infrastructure;

namespace CareBaby.Infrastructure.Services;

public class DateTimeService : IDateTimeService
{
    public DateTimeOffset DateTimeOffsetNow => DateTimeOffset.Now;
    public DateTimeOffset DateTimeOffsetUtcNow => DateTimeOffset.UtcNow;

    public DateTime UnixTimeStampToDateTime(long unixTimeStamp)
    {
        var dateTimeVal = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        dateTimeVal = dateTimeVal.AddSeconds(unixTimeStamp).ToUniversalTime();

        return dateTimeVal;
    }
}
