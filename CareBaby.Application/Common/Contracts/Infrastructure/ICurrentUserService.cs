namespace CareBaby.Application.Common.Contracts.Infrastructure;

public interface ICurrentUserService
{
    Guid? UserId { get; }
}