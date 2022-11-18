using CareBaby.Domain.Common;

namespace CareBaby.Application.Common.Contracts.Infrastructure;

public interface IDomainEventService
{
    Task Publish(BaseDomainEvent domainEvent);
}