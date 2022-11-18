using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class VaccineType : EntityBase<Guid>
    {
        public VaccineType()
        {
            Vaccines = new HashSet<Vaccine>();
        }

        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public string? Notes { get; set; }

        public virtual ICollection<Vaccine> Vaccines { get; set; }
    }
}
