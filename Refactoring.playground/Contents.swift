/*:
 # Refactoring
 
 ![decorator pattern.png](refactoring.png)
 */
enum MovieType : String{
    case REGULAR , CHILDRENS, NEW_RELEASE
}

enum calculateRentalMethodolgy : String{
    case DEFAULT, SUGRED, BLACKFRIDAY
}
struct Movie{
    var id : Int
    var title : String
    var price : Double
    var type : MovieType
}

class Customer {
    var id : Int
    var name : String
    var rentals : [Rental] = []
    
    init(id : Int, name : String) {
        self.id = id
        self.name = name
    }
    
    func addRental(rental: Rental) {
        rentals.append(rental)
    }
}

protocol CalculateRentalPriceDelegate {
    var rent : Rental {get}
    func getRentalCost() -> Double
}


class DefaultMovieCostCalculator : CalculateRentalPriceDelegate{
    var rent: Rental
    init(rent: Rental) {
        self.rent = rent
    }
    func getRentalCost() -> Double {
        return rent.movie.price * Double(rent.numOfDays)
    }
}


class SurgedMovieCostCalculator : CalculateRentalPriceDelegate{
    var rent: Rental
    var surgFactory = 1.5
    init(rent: Rental) {
        self.rent = rent
    }
    
    func getRentalCost() -> Double {
        return rent.movie.price * Double(rent.numOfDays) * surgFactory
    }
}

class MovieTypeBasedCalculator : CalculateRentalPriceDelegate{
    var rent: Rental
    init(rent: Rental) {
        self.rent = rent
    }
    
    func getRentalCost() -> Double {
        return 0.0
    }
}


class Rental {
    var movie : Movie
    var numOfDays : Int
    var calculateRentalMethodolgy : calculateRentalMethodolgy = .DEFAULT
    var rentalCostCalucatorDelegate : CalculateRentalPriceDelegate?
    
    init(numOfDays : Int,movie : Movie,calculationWay : calculateRentalMethodolgy = .DEFAULT) {
        self.numOfDays = numOfDays
        self.movie = movie
        self.calculateRentalMethodolgy = calculationWay
        rentalCostCalucatorDelegate = FactoryCalculator(calculationWay: calculateRentalMethodolgy,
                                                        rent: self).getSutbaleCalculationWay()
    }
    
    func getRentalCost() -> Double {
        return (rentalCostCalucatorDelegate!.getRentalCost())
    }
}

class FactoryCalculator {
    var calculationWay : calculateRentalMethodolgy
    var rent : Rental
    init(calculationWay : calculateRentalMethodolgy,rent : Rental) {
        self.calculationWay = calculationWay
        self.rent = rent
    }
    
    func getSutbaleCalculationWay() -> CalculateRentalPriceDelegate {
        switch self.calculationWay {
        case .DEFAULT:
            return DefaultMovieCostCalculator(rent: rent)
        case .SUGRED:
            return SurgedMovieCostCalculator(rent: rent)
        default:
            return DefaultMovieCostCalculator(rent: rent)
        }
    }
}

protocol PrintChargesDelegte{
    func printReciet() -> String
}


class CustomerChargesCalculator {
    var customer : Customer
    init(customer : Customer) {
        self.customer = customer
    }
    
    func calculateUserTotalCost() -> Double {
        var totalCost = 0.0
        for rental in customer.rentals {
            totalCost += rental.getRentalCost()
        }
        return totalCost
    }
    
    func printRecipet() -> String {
        let costString = calculateUserTotalCost()
        return ("🍿🎞🍿🎞 Cusomer: \(customer.name) Cost is : \(costString)")
    }
}


var titanic = Movie(id: 1, title: "Titanic", price: 14.99, type: .NEW_RELEASE)
var abo3atef = Customer(id: 1, name: "Ahmad Atef")
var abo3aTefMovieRent = Rental(numOfDays: 3, movie: titanic, calculationWay: .DEFAULT)

abo3atef.addRental(rental: abo3aTefMovieRent)
abo3atef.addRental(rental: abo3aTefMovieRent)
abo3atef.addRental(rental: abo3aTefMovieRent)

var atefTotalCost = CustomerChargesCalculator(customer: abo3atef)

print(atefTotalCost.printRecipet())



