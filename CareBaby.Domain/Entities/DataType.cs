using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class DataType : EntityBase<Guid>
    {
        public DataType()
        {
            SettingEmails = new HashSet<SettingEmail>();
            SettingGenerals = new HashSet<SettingGeneral>();
            SettingSecurityTokens = new HashSet<SettingSecurityToken>();
        }

        public string Name { get; set; } = null!;
        public string? Alias { get; set; }
        public string? Description { get; set; }

        public virtual User? CreatedBy { get; set; }
        public virtual User? LastModifiedBy { get; set; }
        public virtual ICollection<SettingEmail> SettingEmails { get; set; }
        public virtual ICollection<SettingGeneral> SettingGenerals { get; set; }
        public virtual ICollection<SettingSecurityToken> SettingSecurityTokens { get; set; }
    }
}
