final class AsyncExecutorMock: AsyncExecutorProtocol {
    func run(_ operation: @escaping () async -> Void) {
        Task {
            await operation()
        }
    }
}
