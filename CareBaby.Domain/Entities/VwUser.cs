using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class VwUser : EntityBase<Guid>
    {
        public string? Email { get; set; }
        public bool EmailConfirmed { get; set; }
        public string Username { get; set; } = null!;
        public string? Title { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? MiddleNames { get; set; }
        public string? FirstNameAndLastName { get; set; }
        public string? Gender { get; set; }
        public DateTimeOffset? Dob { get; set; }
        public short Type { get; set; }
        public string? Mobile { get; set; }
        public string? Address1 { get; set; }
        public string? Address2 { get; set; }
        public string? Suburb { get; set; }
        public string? State { get; set; }
        public string? Postcode { get; set; }
        public string? Country { get; set; }
        public bool? IsPostalSameAsStreetAddress { get; set; }
        public string? PostalAddress1 { get; set; }
        public string? PostalAddress2 { get; set; }
        public string? PostalSuburb { get; set; }
        public string? PostalState { get; set; }
        public string? PostalPostcode { get; set; }
        public string? PostalCountry { get; set; }
        public bool? HasAdministratorRole { get; set; }
        public bool? HasCorporateRole { get; set; }
        public bool? HasStudentRole { get; set; }
        public bool? HasTrainerRole { get; set; }
    }
}
