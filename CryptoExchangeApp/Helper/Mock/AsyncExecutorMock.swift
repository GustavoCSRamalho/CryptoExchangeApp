final class AsyncExecutorMock: AsyncExecutorProtocol {
    var executedOperations: [() async -> Void] = []
        
    func run(_ operation: @escaping () async -> Void) {
        executedOperations.append(operation)
        
        Task {
            await operation()
        }
    }
}
