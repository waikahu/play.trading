using System;

namespace Play.Trading.Service.Exceptions
{
    [Serializable]
    internal class UnknownItemException : Exception
    {
        public UnknownItemException(Guid itemId) : base($"Unknown item '{itemId}'")
        {
            this.ItemId = itemId;
        }

        public Guid ItemId { get; set; }
    }
}