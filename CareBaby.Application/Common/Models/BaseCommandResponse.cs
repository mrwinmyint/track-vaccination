using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Common.Models;

public class BaseCommandResponse<T>
{
    public T Id { get; set; }
    public bool Succeeded { get; set; } = false;
    public IEnumerable<BaseError> Errors { get; set; } = null;
    public string Message { get; set; }
}
