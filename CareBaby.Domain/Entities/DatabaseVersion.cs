using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class DatabaseVersion : EntityBase<Guid>
    {
        public int Version { get; set; }
        public string? VersionLabel { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
