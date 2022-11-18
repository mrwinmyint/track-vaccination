using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class ActionLog : EntityBase<Guid>
    {
        public Guid CustomEntityId { get; set; }
        public Guid? EntityUniqueId { get; set; }
        public string? EntityJson { get; set; }
        public string? Email { get; set; }
        public string? SignedInRole { get; set; }
        public short ActionTypeId { get; set; }
        public DateTimeOffset ActionDateTime { get; set; }
        public Guid? ActionedBy { get; set; }
        public string? ActionReason { get; set; }
        public string? Notes { get; set; }

        public virtual User? User { get; set; }
        public virtual CustomEntity CustomEntity { get; set; } = null!;
    }
}
