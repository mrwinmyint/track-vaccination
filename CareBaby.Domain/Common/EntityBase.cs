using MediatR;
using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace CareBaby.Domain.Common
{
    public abstract class EntityBase<TId> : IEntityBase<TId>
    {
        public virtual TId Id { get; protected set; }
        public virtual bool IsActive { get; set; }
        public virtual bool IsDeleted { get; set; }
        public virtual DateTimeOffset Created { get; set; }
        public virtual Guid? CreatedById { get; set; }
        public virtual string? CreatedByName { get; set; }
        public virtual DateTimeOffset? LastModified { get; set; }
        public virtual Guid? LastModifiedById { get; set; }
        public virtual string? LastModifiedByName { get; set; }
        private int? _requestedHashCode;
        private List<INotification> _domainEvents;

        public List<INotification> DomainEvents => _domainEvents;
        public void AddDomainEvent(INotification eventItem) 
        { 
            _domainEvents ??= new List<INotification>(); 
            _domainEvents.Add(eventItem); 
        }

        public void RemoveDomainEvent(INotification eventItem) 
        { 
            if (_domainEvents is null) return; 
            _domainEvents.Remove(eventItem); 
        }

        public bool IsTransient()
        {
            return Id.Equals(default(TId));
        }

        public override bool Equals(object obj)
        {
            if (obj == null || obj is not EntityBase<TId>)
                return false;

            if (ReferenceEquals(this, obj))
                return true;

            if (GetType() != obj.GetType())
                return false;

            var item = (EntityBase<TId>)obj;

            if (item.IsTransient() || IsTransient())
                return false;
            else
                return item == this;
        }

        public override int GetHashCode()
        {
            if (!IsTransient())
            {
                if (!_requestedHashCode.HasValue)
                    _requestedHashCode = Id.GetHashCode() ^ 31; // XOR for random distribution (http://blogs.msdn.com/b/ericlippert/archive/2011/02/28/guidelines-and-rules-for-gethashcode.aspx)

                return _requestedHashCode.Value;
            }
            else
                return base.GetHashCode();
        }
    }
}