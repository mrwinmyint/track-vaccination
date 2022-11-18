using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Domain.Common;

public interface IHasDomainEvent
{
    public List<BaseDomainEvent> DomainEvents { get; set; }
}

public abstract class BaseDomainEvent : INotification
{
    public BaseDomainEvent()
    {
        EventId = Guid.NewGuid();
        CreatedOn = DateTime.UtcNow;
    }

    public virtual Guid EventId { get; init; }
    public virtual DateTime CreatedOn { get; protected set; } = DateTime.UtcNow;
    public virtual bool IsPublished { get; set; }
}
