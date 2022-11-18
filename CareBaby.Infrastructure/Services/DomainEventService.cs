using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Common.Models;
using CareBaby.Domain.Common;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Infrastructure.Services;

public class DomainEventService : IDomainEventService
{
    private readonly ILogger<DomainEventService> _logger;
    private readonly IPublisher _mediator;

    public DomainEventService(ILogger<DomainEventService> logger, 
        IPublisher mediator)
    {
        _logger = logger;
        _mediator = mediator;
    }

    public async Task Publish(BaseDomainEvent domainEvent)
    {
        _logger.LogInformation($"Publishing domain event. Event - {domainEvent.GetType().Name}");
        await _mediator.Publish(GetNotificationCorrespondingToDomainEvent(domainEvent));
    }

    private INotification GetNotificationCorrespondingToDomainEvent(BaseDomainEvent domainEvent)
    {
        return (INotification)Activator.CreateInstance(typeof(DomainEventNotification<>).MakeGenericType(domainEvent.GetType()), domainEvent)!;
    }
}
