//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyContract {
    
    enum AuctionStatus {
        ONGOING,
        PROCESSING,
        OVER
    }
    AuctionStatus auctionStatus = AuctionStatus.ONGOING;

    // struct for roles
    struct Manufacturer {
        string name;
        string supplierForTyres;
        string supplierForBody;
        address payable manufacturerAddress;
        bytes hashedTyreBidQuantity;
        bytes hashedTyreBidPrice;
        bytes hashedCarBodyBidQuantity;
        bytes hashedCarBodyBidPrice;
        uint256[] tyre;
        uint256[] carBody;
        uint256 carPrice;
        bool paid;
    }

    struct Car {
        string manufacturer;
        int256 tyreId;
        int256 carBodyId;
        string supplierForTyres;
        string supplierForBody;
        address manufacturerAddress;
    }

    struct Customer {
        string name;
        address customerAddress;
        Car car;
    }

    struct CarBodySupplier {
        string name;
        //string supplierType;
        address payable carBodySupplierAddress;
        uint256[] item;
        uint256 limit;
    }

    struct CarTyreSupplier {
        string name;
        //string supplierType;
        string suppliesTo;
        address payable carTyreSupplierAddress;
        uint256[] item;
        uint256 limit;
    }

    //variables used for actors

    Manufacturer TataManufacturer;
    Manufacturer MaruthiManufacturer;

    CarBodySupplier carBodySupplier;

    CarTyreSupplier MrfCarTyreSupplier;
    CarTyreSupplier CeatCarTyreSupplier;

    Customer[] customer;

    //add modifiers to the view functions
    modifier OnlyCarBodySupplier() {
        require(msg.sender == carBodySupplier.carBodySupplierAddress);
        _;
    }

    modifier OnlyTATA() {
        require(
            msg.sender == TataManufacturer.manufacturerAddress,
            "Access is available only to Tata"
        );
        _;
    }

    modifier OnlyMaruti() {
        require(
            msg.sender == MaruthiManufacturer.manufacturerAddress,
            "Access is available only to Maruti"
        );

        _;
    }

    modifier OnlyMrf() {
        require(
            msg.sender == MrfCarTyreSupplier.carTyreSupplierAddress,
            "Access is available only to Mrf"
        );
        _;
    }

    modifier OnlyCeat() {
        require(
            msg.sender == CeatCarTyreSupplier.carTyreSupplierAddress,
            "Access is available only to Ceat"
        );
        _;
    }

    modifier WhenAuctionOngoing() {
        require(
            auctionStatus == AuctionStatus.ONGOING,
            "The auction is not ongoing"
        );
        _;
    }

    modifier WhenAuctionProcessing() {
        require(
            auctionStatus == AuctionStatus.PROCESSING,
            "The auction is not in the processing stage"
        );

        _;
    }

    modifier WhenAuctionOver() {
        require(auctionStatus == AuctionStatus.OVER, "The auction is not over");
        _;
    }

    //variables for setting supply limits-------

    uint256 CarTyreSupplierLimit_MRF;
    uint256 CarTyreSupplierLimit_CEAT;
    uint256 CarBodySupplierLimit_VEDANTHA;

    //uint CarBodySupplierLimit_VEDANTHA;

    uint256 NumberOfCarBodiesNeeded_TATA = numberOfCarBodiesNeeded_TATA();
    uint256 NumberOfCarBodiesNeeded_MARUTHI = numberOfCarBodiesNeeded_MARUTHI();

    //Listing all the manufacturers and suppliers------------------------------------------------------

    function setTataManufacturer(
        string memory Name,
        string memory Tyres,
        string memory Body
    ) public {
        TataManufacturer.name = Name;
        TataManufacturer.supplierForTyres = Tyres;
        TataManufacturer.supplierForBody = Body;
        TataManufacturer.manufacturerAddress = payable(msg.sender);
        TataManufacturer.paid = false;
    }

    function setMaruthiManufacturer(
        string memory Name,
        string memory Tyres,
        string memory Body
    ) public {
        MaruthiManufacturer.name = Name;
        MaruthiManufacturer.supplierForTyres = Tyres;
        MaruthiManufacturer.supplierForBody = Body;
        MaruthiManufacturer.manufacturerAddress = payable(msg.sender);
        MaruthiManufacturer.paid = false;
    }

    function setVedanthaSupplier(string memory Name) public {
        carBodySupplier.name = Name;
        carBodySupplier.carBodySupplierAddress = payable(msg.sender);
    }

    function setMrfSupplier(string memory Name, string memory SuppliesTo)
        public
    {
        MrfCarTyreSupplier.name = Name;
        MrfCarTyreSupplier.suppliesTo = SuppliesTo;
        MrfCarTyreSupplier.carTyreSupplierAddress = payable(msg.sender);
    }

    function setCeatSupplier(string memory Name, string memory SuppliesTo)
        public
    {
        CeatCarTyreSupplier.name = Name;
        CeatCarTyreSupplier.suppliesTo = SuppliesTo;
        CeatCarTyreSupplier.carTyreSupplierAddress = payable(msg.sender);
    }

    function setCustomer(string memory Name) public {
        customer[customer.length] = Customer({
            name: Name,
            customerAddress: msg.sender,
            car: Car({
                manufacturer: "",
                tyreId: -1,
                carBodyId: -1,
                supplierForTyres: "",
                supplierForBody: "",
                manufacturerAddress: msg.sender
            })
        });
    }

    // Setting supplier limits for tyres------------------------------------------------------
    // the 6 functions below have been tested

    function setCarTyreSupplierLimit_MRF(uint256 limit) public {
        require(
            msg.sender == MrfCarTyreSupplier.carTyreSupplierAddress,
            "Only MRF supplier can set the limit"
        );
        CarTyreSupplierLimit_MRF = limit;
        MrfCarTyreSupplier.limit = limit;
    }

    function viewCarTyreSupplierLimit_MRF() public view returns (uint256) {
        return CarTyreSupplierLimit_MRF;
    }

    function setCarTyreSupplierLimit_CEAT(uint256 limit) public {
        require(
            msg.sender == CeatCarTyreSupplier.carTyreSupplierAddress,
            "Only CEAT supplier can set the limit"
        );
        CarTyreSupplierLimit_CEAT = limit;
        CeatCarTyreSupplier.limit = limit;
    }

    function viewCarTyreSupplierLimit_CEAT() public view returns (uint256) {
        return CarTyreSupplierLimit_CEAT;
    }

    function SetCarBodySupplyLimit_VEDANTHA(uint256 limit) public {
        require(
            msg.sender == carBodySupplier.carBodySupplierAddress,
            "Only VEDANTHA supplier can set the limit"
        );
        CarBodySupplierLimit_VEDANTHA = limit;
        carBodySupplier.limit = limit;
    }

    function viewCarBodySupplyLimit_VEDANTHA() public view returns (uint256) {
        return CarBodySupplierLimit_VEDANTHA;
    }

    // car body counting------------------------------------------------------------
    // two functions below are tested

    function numberOfCarBodiesNeeded_TATA() public view returns (uint256) {
        return CarTyreSupplierLimit_MRF / 4;
    }

    function numberOfCarBodiesNeeded_MARUTHI() public view returns (uint256) {
        return CarTyreSupplierLimit_CEAT / 4;
    }

    // add unique identifier to the car body and the car tyre

    function addTyre_MRF() public {
        require(
            msg.sender == MrfCarTyreSupplier.carTyreSupplierAddress,
            "Only the supplier can add tyres"
        );
        for (uint256 i = 0; i < MrfCarTyreSupplier.limit; i++) {
            MrfCarTyreSupplier.item.push(i);
        }
    }

    function addTyre_CEAT() public {
        require(
            msg.sender == CeatCarTyreSupplier.carTyreSupplierAddress,
            "Only the supplier can add tyres"
        );
        for (uint256 i = 0; i < CeatCarTyreSupplier.limit; i++) {
            CeatCarTyreSupplier.item.push(i);
        }
    }

    function addBody() public {
        require(
            msg.sender == carBodySupplier.carBodySupplierAddress,
            "Only the supplier can add bodies"
        );
        for (uint256 i = 0; i < carBodySupplier.limit; i++) {
            carBodySupplier.item.push(i);
        }
    }

    // buying the car

    function BuyCar_TATA() public payable {
        // check if msg.sender is in the list of customers
        for (uint256 i = 0; i < customer.length; ++i) {
            if (msg.sender == customer[i].customerAddress) {
                require(
                    msg.value == TataManufacturer.carPrice,
                    "The price paid does not match the price of the car"
                );
                require(
                    TataManufacturer.carBody.length > 0 &&
                        TataManufacturer.tyre.length >= 4,
                    "Out of stock"
                );
                TataManufacturer.manufacturerAddress.transfer(msg.value);
                customer[i].car.manufacturer = TataManufacturer.name;
                customer[i].car.tyreId = int256(
                    TataManufacturer.tyre[TataManufacturer.tyre.length - 1]
                );
                TataManufacturer.tyre.pop();
                customer[i].car.tyreId = int256(
                    TataManufacturer.tyre[TataManufacturer.tyre.length - 1]
                );
                TataManufacturer.tyre.pop();
                customer[i].car.tyreId = int256(
                    TataManufacturer.tyre[TataManufacturer.tyre.length - 1]
                );
                TataManufacturer.tyre.pop();
                customer[i].car.tyreId = int256(
                    TataManufacturer.tyre[TataManufacturer.tyre.length - 1]
                );
                TataManufacturer.tyre.pop();
                customer[i].car.carBodyId = int256(
                    TataManufacturer.carBody[
                        TataManufacturer.carBody.length - 1
                    ]
                );
                TataManufacturer.carBody.pop();
                customer[i].car.supplierForTyres = TataManufacturer
                    .supplierForTyres;
                customer[i].car.supplierForBody = TataManufacturer
                    .supplierForBody;
                customer[i].car.manufacturerAddress = TataManufacturer
                    .manufacturerAddress;
                break;
            }
        }
    }

    function BuyCar_MARUTHI() public payable {
        // check if msg.sender is in the list of customers
        for (uint256 i = 0; i < customer.length; ++i) {
            if (msg.sender == customer[i].customerAddress) {
                require(
                    msg.value == MaruthiManufacturer.carPrice,
                    "The price paid does not match the price of the car"
                );
                require(
                    MaruthiManufacturer.carBody.length > 0 &&
                        MaruthiManufacturer.tyre.length >= 4,
                    "Out of stock"
                );
                MaruthiManufacturer.manufacturerAddress.transfer(msg.value);
                customer[i].car.manufacturer = MaruthiManufacturer.name;
                customer[i].car.tyreId = int256(
                    MaruthiManufacturer.tyre[MaruthiManufacturer.tyre.length - 1]
                );
                MaruthiManufacturer.tyre.pop();
                customer[i].car.tyreId = int256(
                    MaruthiManufacturer.tyre[MaruthiManufacturer.tyre.length - 1]
                );
                MaruthiManufacturer.tyre.pop();
                customer[i].car.tyreId = int256(
                    MaruthiManufacturer.tyre[MaruthiManufacturer.tyre.length - 1]
                );
                MaruthiManufacturer.tyre.pop();
                customer[i].car.tyreId = int256(
                    MaruthiManufacturer.tyre[MaruthiManufacturer.tyre.length - 1]
                );
                MaruthiManufacturer.tyre.pop();
                customer[i].car.carBodyId = int256(
                    MaruthiManufacturer.carBody[
                        MaruthiManufacturer.carBody.length - 1
                    ]
                );
                MaruthiManufacturer.carBody.pop();
                customer[i].car.supplierForTyres = MaruthiManufacturer
                    .supplierForTyres;
                customer[i].car.supplierForBody = MaruthiManufacturer
                    .supplierForBody;
                customer[i].car.manufacturerAddress = MaruthiManufacturer
                    .manufacturerAddress;
                break;

            }
        }
    }

    function ViewCarDetails() public view returns (string memory,string memory,string memory) {
        for (uint256 i = 0; i < customer.length; ++i) {
            if (msg.sender == customer[i].customerAddress) {
                
                 return (customer[i].car.manufacturer,
                 customer[i].car.supplierForTyres,
                 customer[i].car.supplierForBody);
                 
            }
        }
    }


//Bidding contract------------------------------------------------------------------


    enum BidResult {
        WON,
        LOST,
        DRAW
    }

    BidResult tataResult = BidResult.DRAW;
    BidResult maruthiResult = BidResult.DRAW;

    struct Bid {
        uint256 quantity;
        uint256 amount;
    }

    uint256 carBodiesWonInAuction_TATA = 0;
    uint256 carBodiesWonInAuction_MARUTHI = 0;

    //placing for bids

    Bid CarBodySupplierBid_VEDANTHA;
    Bid CarTyreSupplierBid_MRF;
    Bid CarTyreSupplierBid_CEAT;
    Bid CarBodyManufacturerBid_TATA;
    Bid CarBodyManufacturerBid_MARUTHI;
    Bid CarTyreManufacturerBid_TATA;
    Bid CarTyreManufacturerBid_MARUTHI;

    //Supplier Bid Functions --------------------- Input ---------------------- And Outputs -----------------------
    function carBodySupplierBid(uint256 amount) public OnlyCarBodySupplier {
        CarBodySupplierBid_VEDANTHA = Bid(
            CarBodySupplierLimit_VEDANTHA,
            amount
        );
    }

    function viewCarBodySupplierBid() public view returns (Bid memory) {
        return CarBodySupplierBid_VEDANTHA;
    }

    function carTyreSupplierBid_MRF(uint256 amount) public {
        CarTyreSupplierBid_MRF = Bid(CarTyreSupplierLimit_MRF, amount);
    }

    function viewCarTyreSupplierBid_MRF() public view returns (Bid memory) {
        return CarTyreSupplierBid_MRF;
    }

    function carTyreSupplierBid_CEAT(uint256 amount) public {
        CarTyreSupplierBid_CEAT = Bid(CarTyreSupplierLimit_CEAT, amount);
    }

    function viewCarTyreSupplierBid_CEAT() public view returns (Bid memory) {
        return CarTyreSupplierBid_CEAT;
    }

    //Manufacturer Bid Functions --------------------- Input ---------------------- And Outputs -----------------------

  function carBodyManufacturerBid_TATA(
        uint256 quantity,
        uint256 amount,
        uint256 key1,
        uint256 key2
    ) public OnlyTATA {
        require(
            quantity <= CarBodySupplierLimit_VEDANTHA,
            "The bid quantity exceeds the available supply limit"
        );

        TataManufacturer.hashedCarBodyBidQuantity = hash(key1, quantity);
        TataManufacturer.hashedCarBodyBidPrice = hash(key2, amount);
    }

    function hash(uint256 key, uint256 value)
        public
        pure
        returns (bytes memory)
    {
        bytes memory b = abi.encode(key, value);
        return b;
    }

    function unhash(uint256 key, bytes memory value)
        public
        pure
        returns (uint256)
    {
        bytes memory b = value;
        (uint256 k, uint256 v) = abi.decode(b, (uint256, uint256));
        return v;
    }

    function revealBid_TATA(
        uint256 key1,
        uint256 key2,
        uint256 key3,
        uint256 key4
    ) public {
        CarBodyManufacturerBid_TATA = Bid(
            unhash(key1, TataManufacturer.hashedCarBodyBidQuantity),
            unhash(key2, TataManufacturer.hashedCarBodyBidPrice)
        );

        CarTyreManufacturerBid_TATA = Bid(
            unhash(key3, TataManufacturer.hashedTyreBidQuantity),
            unhash(key4, TataManufacturer.hashedTyreBidPrice)
        );
    }

    function revealBid_Maruti(
        uint256 key1,
        uint256 key2,
        uint256 key3,
        uint256 key4
    ) public {
        CarBodyManufacturerBid_MARUTHI = Bid(
            unhash(key1, MaruthiManufacturer.hashedCarBodyBidQuantity),
            unhash(key2, MaruthiManufacturer.hashedCarBodyBidPrice)
        );

        CarTyreManufacturerBid_MARUTHI = Bid(
            unhash(key3, MaruthiManufacturer.hashedTyreBidQuantity),
            unhash(key4, MaruthiManufacturer.hashedTyreBidPrice)
        );
    }

    function viewCarBodyManufacturerBid_TATA()
        public
        view
        returns (Bid memory)
    {
        return CarBodyManufacturerBid_TATA;
    }

    function carBodyManufacturerBid_MARUTHI(
        uint256 quantity,
        uint256 amount,
        uint256 key1,
        uint256 key2
    ) public OnlyMaruti {
        require(
            quantity <= CarBodySupplierLimit_VEDANTHA,
            "The bid quantity exceeds the supply limit"
        );
        MaruthiManufacturer.hashedCarBodyBidQuantity = hash(key1, quantity);
        MaruthiManufacturer.hashedCarBodyBidPrice = hash(key2, amount);
    }

    function viewCarBodyManufacturerBid_MARUTHI()
        public
        view
        returns (Bid memory)
    {
        return CarBodyManufacturerBid_MARUTHI;
    }

    //Tyre Manufacturer Bid Functions --------------------- Input ---------------------- And Outputs -----------------------

    function carTyreManufacturerBid_TATA(
        uint256 quantity,
        uint256 amount,
        uint256 key3,
        uint256 key4
    ) public OnlyTATA {
        require(
            quantity <= CarTyreSupplierLimit_MRF,
            "The bid quantity exceeds the supply limit"
        );
        TataManufacturer.hashedTyreBidQuantity = hash(key3, quantity);
        TataManufacturer.hashedTyreBidPrice = hash(key4, amount);
    }

    function viewCarTyreManufacturerBid_TATA()
        public
        view
        returns (Bid memory)
    {
        return CarTyreManufacturerBid_TATA;
    }

    function carTyreManufacturerBid_MARUTHI(
        uint256 quantity,
        uint256 amount,
        uint256 key3,
        uint256 key4
    ) public OnlyMaruti {
        require(
            quantity <= CarTyreSupplierLimit_CEAT,
            "The bid quantity exceeds the supply limit"
        );
        MaruthiManufacturer.hashedTyreBidQuantity = hash(key3, quantity);
        MaruthiManufacturer.hashedTyreBidPrice = hash(key4, amount);
    }

    function viewCarTyreManufacturerBid_MARUTHI()
        public
        view
        returns (Bid memory)
    {
        return CarTyreManufacturerBid_MARUTHI;
    }

    //Bidding Function ---------------------------------------------
    function biddingForCarBody() public {
        uint256 carBodiesLeftForSupplier_VEDANTHA;

        if (
            CarBodyManufacturerBid_TATA.quantity >
            CarBodySupplierBid_VEDANTHA.quantity &&
            CarBodyManufacturerBid_MARUTHI.quantity >
            CarBodySupplierBid_VEDANTHA.quantity
        ) {
            tataResult = BidResult.LOST;
            maruthiResult = BidResult.LOST;
            carBodiesWonInAuction_TATA = 0;
            carBodiesWonInAuction_MARUTHI = 0;
        } else {
            if (
                CarBodyManufacturerBid_MARUTHI.quantity >
                CarBodySupplierBid_VEDANTHA.quantity &&
                CarBodyManufacturerBid_TATA.quantity <=
                CarBodySupplierBid_VEDANTHA.quantity
            ) {
                tataResult = BidResult.WON;
                maruthiResult = BidResult.LOST;
                carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA
                    .quantity;
                carBodiesWonInAuction_MARUTHI = 0;
            } else if (
                CarBodyManufacturerBid_MARUTHI.quantity <=
                CarBodySupplierBid_VEDANTHA.quantity &&
                CarBodyManufacturerBid_TATA.quantity >
                CarBodySupplierBid_VEDANTHA.quantity
            ) {
                tataResult = BidResult.LOST;
                maruthiResult = BidResult.WON;
                carBodiesWonInAuction_TATA = 0;
                carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI
                    .quantity;
            } else if (
                CarBodyManufacturerBid_MARUTHI.quantity <
                CarBodySupplierBid_VEDANTHA.quantity &&
                CarBodyManufacturerBid_TATA.quantity <
                CarBodySupplierBid_VEDANTHA.quantity
            ) {
                if (
                    CarBodyManufacturerBid_MARUTHI.quantity >
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity >
                    NumberOfCarBodiesNeeded_TATA
                ) {
                    //check the algorithm for this-------------------------------------------------------------------------------------------------------
                    if (
                        CarBodyManufacturerBid_MARUTHI.quantity +
                            CarBodyManufacturerBid_TATA.quantity <=
                        CarBodySupplierBid_VEDANTHA.quantity
                    ) {
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.WON;
                        carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA
                            .quantity;
                        carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI
                            .quantity;
                    } else if (
                        NumberOfCarBodiesNeeded_MARUTHI +
                            NumberOfCarBodiesNeeded_TATA <=
                        CarBodySupplierBid_VEDANTHA.quantity
                    ) {
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.WON;
                        carBodiesWonInAuction_TATA = NumberOfCarBodiesNeeded_TATA;
                        carBodiesWonInAuction_MARUTHI = NumberOfCarBodiesNeeded_MARUTHI;

                        carBodiesLeftForSupplier_VEDANTHA =
                            CarBodySupplierBid_VEDANTHA.quantity -
                            NumberOfCarBodiesNeeded_TATA -
                            NumberOfCarBodiesNeeded_MARUTHI;

                        if (carBodiesLeftForSupplier_VEDANTHA != 0) {
                            if (
                                CarBodyManufacturerBid_MARUTHI.amount >
                                CarBodyManufacturerBid_TATA.amount
                            ) {
                                carBodiesWonInAuction_MARUTHI += carBodiesLeftForSupplier_VEDANTHA;
                            } else {
                                carBodiesWonInAuction_TATA += carBodiesLeftForSupplier_VEDANTHA;
                            }
                        } else {
                            tataResult = BidResult.WON;
                            maruthiResult = BidResult.LOST;
                            carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA
                                .quantity;
                            carBodiesWonInAuction_MARUTHI =
                                CarBodySupplierBid_VEDANTHA.quantity -
                                CarBodyManufacturerBid_TATA.quantity;
                        }
                    }
                } else {
                    if (
                        CarBodyManufacturerBid_MARUTHI.amount >
                        CarBodyManufacturerBid_TATA.amount
                    ) {
                        tataResult = BidResult.LOST;
                        maruthiResult = BidResult.WON;
                        carBodiesWonInAuction_TATA =
                            CarBodySupplierBid_VEDANTHA.quantity -
                            CarBodyManufacturerBid_MARUTHI.quantity;
                        carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI
                            .quantity;
                    } else {
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.LOST;
                        carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA
                            .quantity;
                        carBodiesWonInAuction_MARUTHI =
                            CarBodySupplierBid_VEDANTHA.quantity -
                            CarBodyManufacturerBid_TATA.quantity;
                    }
                }
            } else if (
                CarBodyManufacturerBid_MARUTHI.quantity >
                NumberOfCarBodiesNeeded_MARUTHI &&
                NumberOfCarBodiesNeeded_TATA == NumberOfCarBodiesNeeded_TATA
            ) {
                tataResult = BidResult.WON;
                maruthiResult = BidResult.LOST;
                carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA
                    .quantity;
                carBodiesWonInAuction_MARUTHI =
                    CarBodySupplierBid_VEDANTHA.quantity -
                    CarBodyManufacturerBid_TATA.quantity;
            } else if (
                CarBodyManufacturerBid_MARUTHI.quantity ==
                NumberOfCarBodiesNeeded_MARUTHI &&
                CarBodyManufacturerBid_TATA.quantity >
                NumberOfCarBodiesNeeded_TATA
            ) {
                tataResult = BidResult.LOST;
                maruthiResult = BidResult.WON;
                carBodiesWonInAuction_TATA =
                    CarBodySupplierBid_VEDANTHA.quantity -
                    CarBodyManufacturerBid_MARUTHI.quantity;
                carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI
                    .quantity;
            } else if (
                (CarBodyManufacturerBid_MARUTHI.quantity ==
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity ==
                    NumberOfCarBodiesNeeded_TATA) ||
                (CarBodyManufacturerBid_MARUTHI.quantity <
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity ==
                    NumberOfCarBodiesNeeded_TATA) ||
                (CarBodyManufacturerBid_MARUTHI.quantity ==
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity <
                    NumberOfCarBodiesNeeded_TATA) ||
                (CarBodyManufacturerBid_MARUTHI.quantity <
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity <
                    NumberOfCarBodiesNeeded_TATA)
            ) {
                if (
                    CarBodyManufacturerBid_MARUTHI.amount >
                    CarBodyManufacturerBid_TATA.amount
                ) {
                    tataResult = BidResult.LOST;
                    maruthiResult = BidResult.WON;
                    carBodiesWonInAuction_TATA =
                        CarBodySupplierBid_VEDANTHA.quantity -
                        CarBodyManufacturerBid_MARUTHI.quantity;
                    carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI
                        .quantity;
                } else {
                    tataResult = BidResult.WON;
                    maruthiResult = BidResult.LOST;
                    carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA
                        .quantity;
                    carBodiesWonInAuction_MARUTHI =
                        CarBodySupplierBid_VEDANTHA.quantity -
                        CarBodyManufacturerBid_TATA.quantity;
                }
            }
        }
    }

    function viewBidResult() public view returns (BidResult, BidResult) {
        return (tataResult, maruthiResult);
    }

    function MakePayment() public payable {
        if (tataResult == BidResult.WON) {
            require(
                msg.value ==
                    carBodiesWonInAuction_TATA *
                        CarBodyManufacturerBid_TATA.amount,
                "incorrect amount"
            );
            carBodySupplier.carBodySupplierAddress.transfer(msg.value);
            TataManufacturer.paid = true;
        } else if (maruthiResult == BidResult.WON) {
            require(
                msg.value ==
                    carBodiesWonInAuction_MARUTHI *
                        CarBodyManufacturerBid_MARUTHI.amount,
                "incorrect amount"
            );
            carBodySupplier.carBodySupplierAddress.transfer(msg.value);
            MaruthiManufacturer.paid = true;
        }
    }

    function TransferCarBody() public payable {
        if (tataResult == BidResult.WON) {
            require(
                msg.sender == carBodySupplier.carBodySupplierAddress,
                "only supplier can transfer the ownership"
            );
            //require(
              //  TataManufacturer.paid == true,
                //"payment of the bid is pending by the manufacturer"
            //);
            for (uint256 i = 0; i < carBodiesWonInAuction_TATA; ++i) {
                TataManufacturer.carBody.push(
                    carBodySupplier.item[carBodySupplier.item.length - 1]
                );
                carBodySupplier.item.pop();
            }
        }
        if (maruthiResult == BidResult.WON) {
            require(
                msg.sender == carBodySupplier.carBodySupplierAddress,
                "only supplier can transfer the ownership"
            );
           // require(
              //MaruthiManufacturer.paid == true,
                //"payment of the bid is pending by the manufacturer"
            //);
            for (uint256 i = 0; i < carBodiesWonInAuction_MARUTHI; ++i) {
                MaruthiManufacturer.carBody.push(
                    carBodySupplier.item[carBodySupplier.item.length - 1]
                );
                carBodySupplier.item.pop();
            }
        }
    }

    function TransferCarTyre() public payable {
        if (tataResult == BidResult.WON) {
            require(
                msg.sender == carBodySupplier.carBodySupplierAddress,
                "only supplier can transfer the ownership"
            );
            require(
                TataManufacturer.paid == true,
                "payment of the bid is pending by the manufacturer"
            );
            for (uint256 i = 0; i < CarTyreSupplierBid_MRF.quantity; ++i) {
                TataManufacturer.tyre.push(
                    MrfCarTyreSupplier.item[MrfCarTyreSupplier.item.length - 1]
                );
                MrfCarTyreSupplier.item.pop();
            }
        }
        if (maruthiResult == BidResult.WON) {
            require(
                msg.sender == carBodySupplier.carBodySupplierAddress,
                "only supplier can transfer the ownership"
            );
            require(
                MaruthiManufacturer.paid == true,
                "payment of the bid is pending by the manufacturer"
            );
            for (uint256 i = 0; i < CarTyreSupplierBid_MRF.quantity; ++i) {
                MaruthiManufacturer.tyre.push(
                    CeatCarTyreSupplier.item[
                        CeatCarTyreSupplier.item.length - 1
                    ]
                );
                CeatCarTyreSupplier.item.pop();
            }
        }
    }
}
