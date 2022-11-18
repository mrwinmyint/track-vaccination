using CareBaby.Domain.Common;
using CareBaby.Domain.Identity;
using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Entities
{
    public partial class RefreshToken : EntityBase<Guid>
    {
        public string JwtId { get; set; } = null!;
        public Guid UserId { get; set; }
        public bool IsUsed { get; set; }
        public bool IsRevoked { get; set; }
        public DateTimeOffset AddedDate { get; set; }
        public DateTimeOffset? ExpiryDate { get; set; }
        public string? Token { get; set; }
        public string? RoleName { get; set; }

        public virtual ApplicationUser User { get; set; } = null!;
    }
}
