//
//  DogListRepository.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import UIKit
import Combine
import CoreData

class DogListRepository: DogListRepositoryProtocol {
    
    func getDogs() -> AnyPublisher<[Dog], Error>? {
        deleteAllDogs()
        return ApiRest.shared.get(component: "1151549092634943488")
    }
    
    private func deleteAllDogs() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dogs")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = AppDelegate.persistentContainer.viewContext
        _ = try? context.execute(deleteRequest)
        _ = try? context.save()
    }
    
    func setLocalDogs(dogs: [Dog]) -> Bool {
        let context = AppDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Dogs", in: context) else { return false }
        
        for dog in dogs {
            let newDog = NSManagedObject(entity: entity, insertInto: context)
            newDog.setValue(dog.age, forKey: "age")
            newDog.setValue(dog.description, forKey: "desc")
            newDog.setValue(dog.dogName, forKey: "dogName")
            newDog.setValue(dog.image, forKey: "image")
        }
    
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func getLocalDogs() -> AnyPublisher<[Dog], Error>?  {
        let context = AppDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dogs")
        request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        return Future { completion in
            
            var dogs: [Dog] = [Dog]()
            
            do {
                let result = try context.fetch(request) as? [NSManagedObject] ?? []
                
                for data in result {
                    guard let dogName = data.value(forKey: "dogName") as? String else { continue }
                    guard let description = data.value(forKey: "desc") as? String else { continue }
                    guard let age = data.value(forKey: "age") as? Int else { continue }
                    guard let image = data.value(forKey: "image") as? String else { continue }
                    
                    let newDog = Dog(dogName: dogName,
                                     description: description,
                                     age: age,
                                     image: image)
                    dogs.append(newDog)
                }
                
            } catch let error {
                completion(.failure(error))
            }
            
            completion(.success(dogs))
        }.eraseToAnyPublisher()
    }
}
