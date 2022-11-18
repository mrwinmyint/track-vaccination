using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Domain.Enums
{
    public class UserType : Enumeration
    {
        public static UserType Guardian = new(1, nameof(Guardian));
        public static UserType Doctor = new(1, nameof(Doctor));
        public UserType(int id, string name)
            : base(id, name) 
        {
        }
    }
}
