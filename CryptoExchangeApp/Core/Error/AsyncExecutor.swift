import Foundation

protocol AsyncExecutorProtocol {
    func run(_ operation: @escaping () async -> Void)
}

final class AsyncExecutor: AsyncExecutorProtocol {
    func run(_ operation: @escaping () async -> Void) {
        Task.detached(priority: .background) {
            await operation()
        }
    }
}


final class AsyncExecutorMock: AsyncExecutorProtocol {
    func run(_ operation: @escaping () async -> Void) {
        Task {
            await operation()
        }
    }
}
