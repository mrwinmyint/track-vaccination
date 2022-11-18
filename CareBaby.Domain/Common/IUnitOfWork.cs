using System.Threading.Tasks;

namespace CareBaby.Domain.Common
{
    public interface IUnitOfWork : IDisposable
    {
        Task<int> CommitAsync();

        T AsyncRepository<T>(ref T member);
    }
}