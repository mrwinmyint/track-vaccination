using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class Dose : EntityBase<Guid>
    {
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public string? Notes { get; set; }
    }
}
