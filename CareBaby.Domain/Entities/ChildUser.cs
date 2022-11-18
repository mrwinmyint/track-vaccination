using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class ChildUser : EntityBase<Guid>
    {
        public Guid ParentId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Gender { get; set; }
        public DateTimeOffset? Dob { get; set; }
        public string? MiddleNames { get; set; }
        public string? FirstNameAndLastName { get; set; }

        public virtual User Parent { get; set; } = null!;
    }
}
