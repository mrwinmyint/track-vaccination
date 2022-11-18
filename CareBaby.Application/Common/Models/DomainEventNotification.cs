using CareBaby.Domain.Common;
using MediatR;

namespace CareBaby.Application.Common.Models;

public class DomainEventNotification<TDomainEvent> : INotification where TDomainEvent : BaseDomainEvent
{
    public DomainEventNotification(TDomainEvent domainEvent)
    {
        DomainEvent = domainEvent;
    }

    public TDomainEvent DomainEvent { get; }
}