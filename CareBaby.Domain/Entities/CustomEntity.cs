using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class CustomEntity : EntityBase<Guid>
    {
        public CustomEntity()
        {
            ActionLogs = new HashSet<ActionLog>();
        }

        public string DefaultEntityName { get; set; } = null!;
        public string? DisplayEntityName { get; set; }
        public string? Description { get; set; }
        public bool? IsSystemEntity { get; set; }
        public bool IsStrictEntity { get; set; }

        public virtual User? CreatedBy { get; set; }
        public virtual User? LastModifiedBy { get; set; }
        public virtual ICollection<ActionLog> ActionLogs { get; set; }
    }
}
