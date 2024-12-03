import time

def consume_memory(size_in_mb, duration_seconds=10):
    """
    Attempt to allocate a specified amount of memory for a certain duration.

    Parameters:
    - size_in_mb (int): The amount of memory to consume, in megabytes.
    - duration_seconds (int): The duration for which to retain the memory allocation, in seconds.

    Note: This function is an approximation and actual memory usage may vary slightly.
    """
    bytes_in_mb = 1024 * 1024  # Number of bytes in one megabyte
    try:
        print(f"Allocating {size_in_mb} MB of memory...")
        # Allocate a bytes array of the specified size
        allocated_memory = b'\0' * (size_in_mb * bytes_in_mb)
        print(f"Successfully allocated {size_in_mb} MB of memory. Holding for {duration_seconds} seconds...")
        time.sleep(duration_seconds)  # Hold the memory allocation for the specified duration
    except MemoryError:
        print("Memory allocation failed. Trying to allocate a smaller amount or ensure enough system memory is available.")
    finally:
        print("Releasing memory...")
        del allocated_memory  # Attempt to free the allocated memory

# Example usage:
consume_memory(100, 100)  # Attempt to consume 100 MB of memory for 10 seconds