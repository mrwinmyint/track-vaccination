namespace CareBaby.Domain.Common
{
    public interface IEntityBase<TId>
    {
        TId Id { get; }

        bool IsActive { get; }
        bool IsDeleted { get; }
    }
}















