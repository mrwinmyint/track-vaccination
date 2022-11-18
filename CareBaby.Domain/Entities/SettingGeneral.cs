using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class SettingGeneral : EntityBase<Guid>
    {
        public string Name { get; set; } = null!;
        public Guid DataType { get; set; }
        public string? Value { get; set; }
        public bool IsNullable { get; set; }
        public string Description { get; set; } = null!;

        public virtual User? CreatedBy { get; set; }
        public virtual DataType SettingGeneralDataType { get; set; } = null!;
        public virtual User? LastModifiedBy { get; set; }
    }
}
