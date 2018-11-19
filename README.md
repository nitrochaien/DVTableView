# DVTableView
Fully customize UITableViewController for easier implementation and usage.

## Versions
- Swift 4.2
- XCode 10.1
- iOS 12


## Features

- [x] Customizable HeaderView/FooterView.
- [x] Embeded in and Customizable Pull-to-Refresh.
- [x] 2 types of Load more + Customizable.
- [x] Embeded Alamofire Reachability. Automatically run if possible.
- [x] Show customizable no data view when datasource is empty.
- [x] 1 line of code to set datasource.
- [x] Generic UITableView that can handle any type of data object and custom cell.

## Installation
### Manual
Just drop the **DVTableViewController.swift** and **ReachableManager.swift** files into your project. That's it!

### CocoaPods
Coming soon...

## Example

NOTE: All public functions can be set when initialize DVTableViewController of in **viewDidLoad()** of descendants.

### Child ViewController
```swift
//Define as follows:
class SampleDVTableViewController: DVTableViewController<SampleDVCell, ItemSource> {...}

class SampleDVCell: DVGenericCell<ItemSource> {...}

class ItemSource {...}
```
NOTE: If you want to create custom cell, you have to register that cell in **viewDidLoad()** of child viewcontroller.

### HeaderFooterView
Simply define a view extends from **UITableViewHeaderFooterView** and call set functions.

NOTE: custom view must override reuseIdentifier init function
```swift
override init(reuseIdentifier: String?) {...}
```
```swift
//declare custom view with specific height. Default height value is 30.
setHeaderView(withView: CustomHeader(reuseIdentifier: "CustomHeader"), height: 80)
setFooterView(withView: CustomHeaderFooter(reuseIdentifier: "CustomHeaderFooter"))
```

### Set/Append Data
It's only one function call!

```swift
let array = Array(repeating: ItemSource(title: "Yo"), count: 10)
//Example of set a string array datasource.
setData(array)
//Example of append a string array datasource.
self.appendData(array)
```

### Custom Pull-to-Refresh
```swift
let customView = UIView()
setRefreshControl(customView)
```

### Custom No-data-View
NOTE: customView must have height.
```swift
let customView = UIView()
customView.translatesAutoresizingMaskIntoConstraints = false
customView.heightAnchor.constraint(equalToConstant: 300).isActive = true
setNoDataView(customView)
```

## Want to help?
Got a bug fix, or a new feature? Create a pull request and go for it!

## Author
**Nam Dinh Vu**
- [Github](https://github.com/nitrochaien)
- [LinkedIn](https://www.linkedin.com/in/andeevy/)

## Thank you and Happy coding! Cheers!
