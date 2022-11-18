using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Domain.Enums;

public class UserRole : Enumeration
{
    public static UserRole Administrator = new(1, nameof(Administrator));
    public static UserRole Member = new(2, nameof(Member));
    public static UserRole Public = new(3, nameof(Public));

    public UserRole(int id, string name)
        : base(id, name)
    {
    }
}