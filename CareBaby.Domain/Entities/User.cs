using CareBaby.Domain.Common;
using CareBaby.Domain.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace CareBaby.Domain.Entities
{
    public partial class User : EntityBase<Guid>
    {
        public User()
        {
            ActionLogs = new HashSet<ActionLog>();
            ChildUsers = new HashSet<ChildUser>();
            CustomEntityCreatedBies = new HashSet<CustomEntity>();
            CustomEntityLastModifiedBies = new HashSet<CustomEntity>();
            DataTypeCreatedBies = new HashSet<DataType>();
            DataTypeLastModifiedBies = new HashSet<DataType>();
            SettingEmailCreatedBies = new HashSet<SettingEmail>();
            SettingEmailLastModifiedBies = new HashSet<SettingEmail>();
            SettingGeneralCreatedBies = new HashSet<SettingGeneral>();
            SettingGeneralLastModifiedBies = new HashSet<SettingGeneral>();
            SettingSecurityTokenCreatedBies = new HashSet<SettingSecurityToken>();
            SettingSecurityTokenLastModifiedBies = new HashSet<SettingSecurityToken>();
            UserAddressCreatedBies = new HashSet<UserAddress>();
            UserAddressLastModifiedBies = new HashSet<UserAddress>();
            UserAddressUsers = new HashSet<UserAddress>();
        }
        [Key]
        public Guid Id { get; set; }
        public string? Title { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Gender { get; set; }
        public DateTimeOffset? Dob { get; set; }
        public string? MiddleNames { get; set; }
        /// <summary>
        /// The user type to differentiate entitlements, user type can be Domestic or International. (maybe more in the future?)
        /// </summary>
        public short Type { get; set; }
        public string? FirstNameAndLastName { get; set; }

        public virtual ApplicationUser AspNetUsers { get; set; } = null!;
        public virtual ICollection<ActionLog> ActionLogs { get; set; }
        public virtual ICollection<ChildUser> ChildUsers { get; set; }
        public virtual ICollection<CustomEntity> CustomEntityCreatedBies { get; set; }
        public virtual ICollection<CustomEntity> CustomEntityLastModifiedBies { get; set; }
        public virtual ICollection<DataType> DataTypeCreatedBies { get; set; }
        public virtual ICollection<DataType> DataTypeLastModifiedBies { get; set; }
        public virtual ICollection<SettingEmail> SettingEmailCreatedBies { get; set; }
        public virtual ICollection<SettingEmail> SettingEmailLastModifiedBies { get; set; }
        public virtual ICollection<SettingGeneral> SettingGeneralCreatedBies { get; set; }
        public virtual ICollection<SettingGeneral> SettingGeneralLastModifiedBies { get; set; }
        public virtual ICollection<SettingSecurityToken> SettingSecurityTokenCreatedBies { get; set; }
        public virtual ICollection<SettingSecurityToken> SettingSecurityTokenLastModifiedBies { get; set; }
        public virtual ICollection<UserAddress> UserAddressCreatedBies { get; set; }
        public virtual ICollection<UserAddress> UserAddressLastModifiedBies { get; set; }
        public virtual ICollection<UserAddress> UserAddressUsers { get; set; }
    }
}
