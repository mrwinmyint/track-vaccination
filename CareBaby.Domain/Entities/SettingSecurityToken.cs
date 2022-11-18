using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class SettingSecurityToken : EntityBase<Guid>
    {
        public string Name { get; set; } = null!;
        public Guid DataType { get; set; }
        public string? Value { get; set; }
        public bool IsNullable { get; set; }
        public string Description { get; set; } = null!;

        public virtual User? CreatedBy { get; set; }
        public virtual DataType SettingSecurityTokenDataType { get; set; } = null!;
        public virtual User? LastModifiedBy { get; set; }
    }
}
