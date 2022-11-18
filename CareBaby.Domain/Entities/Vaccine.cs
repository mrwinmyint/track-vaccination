using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class Vaccine : EntityBase<Guid>
    {
        public string? Code { get; set; }
        public string Name { get; set; } = null!;
        public Guid? VaccineTypeId { get; set; }
        public string? Description { get; set; }
        public string? Notes { get; set; }
        public string? Version { get; set; }

        public virtual VaccineType? VaccineType { get; set; }
    }
}
