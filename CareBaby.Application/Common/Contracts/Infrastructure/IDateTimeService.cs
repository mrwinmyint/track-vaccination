namespace CareBaby.Application.Common.Contracts.Infrastructure;

public interface IDateTimeService
{
    DateTimeOffset DateTimeOffsetNow { get; }
    DateTimeOffset DateTimeOffsetUtcNow { get; }
    DateTime UnixTimeStampToDateTime(long unixTimeStamp);
}
