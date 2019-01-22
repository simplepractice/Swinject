//
//  Copyright © 2019 Swinject Contributors. All rights reserved.
//

internal final class SynchronizedResolver {
    internal let container: Container

    internal init(container: Container) {
        self.container = container
    }
}

extension SynchronizedResolver: _Resolver {
    internal func _unsafeResolve<Service, Arguments>(
        name: String?,
        option: ServiceKeyOption?,
        invoker: @escaping ((Arguments) -> Any) -> Any
    ) -> Service {
      return container.lock.sync {
        return self.container._unsafeResolve(name: name, option: option, invoker: invoker)
      }
  }

    // swiftlint:disable:next identifier_name
    internal func _resolve<Service, Arguments>(
        name: String?,
        option: ServiceKeyOption?,
        invoker: @escaping ((Arguments) -> Any) -> Any
    ) -> Service? {
        return container.lock.sync {
            self.container._resolve(name: name, option: option, invoker: invoker)
        }
    }
}

extension SynchronizedResolver: Resolver {
    internal func unsafeResolve<Service>(_ serviceType: Service.Type) -> Service {
        return self.container.unsafeResolve(serviceType)
    }

    internal func unsafeResolve<Service>(_ serviceType: Service.Type, name: String?) -> Service {
        return container.lock.sync {
          return self.container.unsafeResolve(serviceType, name: name)
        }
    }

    internal func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.lock.sync {
            self.container.resolve(serviceType)
        }
    }

    internal func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        return container.lock.sync {
            self.container.resolve(serviceType, name: name)
        }
    }
}
