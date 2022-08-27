//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyContract {
    struct Manufacturer {
        string name;
        string supplierForTyres;
        string clientNameForBody;
    }

    struct CarBodySupplier {
        string supplierName;
        //string supplierType;
    }

    struct CarTyreSupplier {
        string supplierName;
        //string supplierType;
        string suppliesTo;
    }

    //variables used for actors

    Manufacturer TataManufacturer;
    Manufacturer MaruthiManufacturer;

    CarBodySupplier carBodySupplier;

    CarTyreSupplier MrfCarTyreSupplier;
    CarTyreSupplier CeatCarTyreSupplier;

    //variables for setting supply limits

    uint256 CarTyreSupplierLimit_MRF;
    uint256 CarTyreSupplierLimit_CEAT;

    //uint CarBodySupplierLimit_VEDANTHA;

    uint256 NumberOfCarBodiesNeeded_TATA = numberOfCarBodiesNeeded_TATA();
    uint256 NumberOfCarBodiesNeeded_MARUTHI = numberOfCarBodiesNeeded_MARUTHI();

    //Listing all the manufacturers and suppliers------------------------------------------------------

    function setTataManufacturer() public {
        TataManufacturer = Manufacturer("TATA", "MRF", "VEDANTA");
    }

    function setMaruthiManufacturer() public {
        MaruthiManufacturer = Manufacturer("MARUTHI", "CEAT", "VEDANTA");
    }

    function setVedanthaSupplier() public {
        carBodySupplier = CarBodySupplier("VEDANTHA");
    }

    function setMrfSupplier() public {
        MrfCarTyreSupplier = CarTyreSupplier("MRF", "TATA");
    }

    function setCeatSupplier() public {
        CeatCarTyreSupplier = CarTyreSupplier("CEAT", "MARUTHI");
    }

    // Setting supplier limits for tyres------------------------------------------------------

    function setCarTyreSupplierLimit_MRF(uint256 limit) public {
        CarTyreSupplierLimit_MRF = limit;
    }

    function viewTyreSupplierLimit() public view returns (uint256) {
        return CarTyreSupplierLimit_MRF;
    }

    function setCarTyreSupplierLimit_CEAT(uint256 limit) public {
        CarTyreSupplierLimit_CEAT = limit;
    }

    function viewCarTyreSupplierLimit_CEAT() public view returns (uint256) {
        return CarTyreSupplierLimit_CEAT;
    }

    // car body counting------------------------------------------------------------

    function numberOfCarBodiesNeeded_TATA() public view returns (uint256) {
        return CarTyreSupplierLimit_MRF / 4;
    }

    function numberOfCarBodiesNeeded_MARUTHI() public view returns (uint256) {
        return CarTyreSupplierLimit_CEAT / 4;
    }

    /*function carBodySupplyLimit_VEDANTHA(uint carBodies) public {
        CarBodySupplierLimit_VEDANTHA = carBodies;
    } 

    function viewCarBodySupplyLimit_VEDANTHA() public view returns(uint){
        return CarBodySupplierLimit_VEDANTHA;
    }*/
}

//Bidding contract------------------------------------------------------------------

contract BidForCarBodies is MyContract {
    enum BidResult {
        WON,
        LOST
    }
    BidResult tataResult;
    BidResult maruthiResult;

    struct Bid {
        uint256 quantity;
        uint256 amount;
    }

    //placing for bids

    Bid CarBodySupplierBid_VEDANTHA;
    Bid CarTyreSupplierBid_MRF;
    Bid CarTyreSupplierBid_CEAT;
    Bid CarBodyManufacturerBid_TATA;
    Bid CarBodyManufacturerBid_MARUTHI;
    Bid CarTyreManufacturerBid_TATA;
    Bid CarTyreManufacturerBid_MARUTHI;

    //Supplier Bid Functions --------------------- Input ---------------------- And Outputs -----------------------
    function carBodySupplierBid(uint256 quantity, uint256 amount) public {
        CarBodySupplierBid_VEDANTHA = Bid(quantity, amount);
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

    function carBodyManufacturerBid_TATA(uint256 quantity, uint256 amount)
        public
    {
        CarBodyManufacturerBid_TATA = Bid(quantity, amount);
    }

    function viewCarBodyManufacturerBid_TATA()
        public
        view
        returns (Bid memory)
    {
        return CarBodyManufacturerBid_TATA;
    }

    function carBodyManufacturerBid_MARUTHI(uint256 quantity, uint256 amount)
        public
    {
        CarBodyManufacturerBid_MARUTHI = Bid(quantity, amount);
    }

    function viewCarBodyManufacturerBid_MARUTHI()
        public
        view
        returns (Bid memory)
    {
        return CarBodyManufacturerBid_MARUTHI;
    }

    //Bidding Function ---------------------------------------------
    function biddingForCarBody() public {
        if (
            CarBodyManufacturerBid_TATA.quantity >
            CarBodySupplierBid_VEDANTHA.quantity &&
            CarBodyManufacturerBid_MARUTHI.quantity >
            CarBodySupplierBid_VEDANTHA.quantity
        ) {
            tataResult = BidResult.LOST;
            maruthiResult = BidResult.LOST;
        } else {
            if (
                CarBodyManufacturerBid_MARUTHI.quantity >
                CarBodySupplierBid_VEDANTHA.quantity &&
                CarBodyManufacturerBid_TATA.quantity <
                CarBodySupplierBid_VEDANTHA.quantity
            ) {
                tataResult = BidResult.WON;
                maruthiResult = BidResult.LOST;
            } else if (
                CarBodyManufacturerBid_MARUTHI.quantity <
                CarBodySupplierBid_VEDANTHA.quantity &&
                CarBodyManufacturerBid_TATA.quantity >
                CarBodySupplierBid_VEDANTHA.quantity
            ) {
                tataResult = BidResult.LOST;
                maruthiResult = BidResult.WON;
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
                    NumberOfCarBodiesNeeded_MARUTHI
                ) {
                    //check the algorithm for this-------------------------------------------------------------------------------------------------------
                    if (
                        CarBodyManufacturerBid_MARUTHI.amount >
                        CarBodyManufacturerBid_TATA.quantity
                    ) {
                        tataResult = BidResult.LOST;
                        maruthiResult = BidResult.WON;
                    } else {
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.LOST;
                    }
                } else if (
                    CarBodyManufacturerBid_MARUTHI.quantity >
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity ==
                    NumberOfCarBodiesNeeded_MARUTHI
                ) {
                    tataResult = BidResult.WON;
                    maruthiResult = BidResult.LOST;
                } else if (
                    CarBodyManufacturerBid_MARUTHI.quantity ==
                    NumberOfCarBodiesNeeded_MARUTHI &&
                    CarBodyManufacturerBid_TATA.quantity >
                    NumberOfCarBodiesNeeded_MARUTHI
                ) {
                    tataResult = BidResult.LOST;
                    maruthiResult = BidResult.WON;
                } else if (
                    (CarBodyManufacturerBid_MARUTHI.quantity ==
                        NumberOfCarBodiesNeeded_MARUTHI &&
                        CarBodyManufacturerBid_TATA.quantity ==
                        NumberOfCarBodiesNeeded_MARUTHI) ||
                    (CarBodyManufacturerBid_MARUTHI.quantity <
                        NumberOfCarBodiesNeeded_MARUTHI &&
                        CarBodyManufacturerBid_TATA.quantity ==
                        NumberOfCarBodiesNeeded_MARUTHI) ||
                    (CarBodyManufacturerBid_MARUTHI.quantity ==
                        NumberOfCarBodiesNeeded_MARUTHI &&
                        CarBodyManufacturerBid_TATA.quantity <
                        NumberOfCarBodiesNeeded_MARUTHI) ||
                    (CarBodyManufacturerBid_MARUTHI.quantity <
                        NumberOfCarBodiesNeeded_MARUTHI &&
                        CarBodyManufacturerBid_TATA.quantity <
                        NumberOfCarBodiesNeeded_MARUTHI)
                ) {
                    if (
                        CarBodyManufacturerBid_MARUTHI.amount >
                        CarBodyManufacturerBid_TATA.quantity
                    ) {
                        tataResult = BidResult.LOST;
                        maruthiResult = BidResult.WON;
                    } else {
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.LOST;
                    }
                }
            }
        }
    }

    function viewBidResult() public view returns (BidResult, BidResult) {
        return (tataResult, maruthiResult);
    }
}
