using CareBaby.Domain.Common;
using CareBaby.Domain.Entities;

namespace CareBaby.Domain.Events;

public class ParentCreatedEvent : BaseDomainEvent
{
    public User ParentUser { get; }
    public ParentCreatedEvent(User parentUser)
    {
        ParentUser = parentUser;
    }
}