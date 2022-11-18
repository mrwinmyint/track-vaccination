using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class UserAddress : EntityBase<Guid>
    {
        public Guid UserId { get; set; }
        public string? Mobile { get; set; }
        public string? Address1 { get; set; }
        public string? Address2 { get; set; }
        public string? Suburb { get; set; }
        public string? State { get; set; }
        public string? Postcode { get; set; }
        public string? Country { get; set; }
        public bool IsPostalSameAsStreetAddress { get; set; }
        public string? PostalAddress1 { get; set; }
        public string? PostalAddress2 { get; set; }
        public string? PostalSuburb { get; set; }
        public string? PostalState { get; set; }
        public string? PostalPostcode { get; set; }
        public string? PostalCountry { get; set; }

        public virtual User? CreatedBy { get; set; }
        public virtual User? LastModifiedBy { get; set; }
        public virtual User User { get; set; } = null!;
    }
}
