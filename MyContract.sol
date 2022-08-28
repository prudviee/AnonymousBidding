//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyContract{

// struct for roles
    struct Manufacturer{
        string name;
        string supplierForTyres;
        string supplierForBody;
        address manufacturerAddress;
    }


    struct CarBodySupplier{
        string name;
        //string supplierType;
        address carBodySupplierAddress;
    }


    struct CarTyreSupplier{
        string name;
        //string supplierType;
        string suppliesTo;
        address carTyreSupplierAddress;
    }


//variables used for actors


    Manufacturer TataManufacturer;
    Manufacturer MaruthiManufacturer;

    CarBodySupplier carBodySupplier;

    CarTyreSupplier MrfCarTyreSupplier;
    CarTyreSupplier CeatCarTyreSupplier;
    
//add modifiers to the view functions
    modifier OnlyCarBodySupplier{
        require(msg.sender == carBodySupplier.carBodySupplierAddress);
        _;
    }

//variables for setting supply limits-------


    uint CarTyreSupplierLimit_MRF;
    uint CarTyreSupplierLimit_CEAT;
    
    //uint CarBodySupplierLimit_VEDANTHA;

    uint NumberOfCarBodiesNeeded_TATA = numberOfCarBodiesNeeded_TATA();
    uint NumberOfCarBodiesNeeded_MARUTHI = numberOfCarBodiesNeeded_MARUTHI();

//Listing all the manufacturers and suppliers------------------------------------------------------


    function setTataManufacturer(string memory Name,string memory Tyres,string memory Body,address Ad) public {
        TataManufacturer.name = Name;
        TataManufacturer.supplierForTyres = Tyres;
        TataManufacturer.supplierForBody = Body;
        TataManufacturer.manufacturerAddress = Ad;
    }

    function setMaruthiManufacturer(string memory Name ,string memory Tyres ,string memory Body ,address Ad) public {
        MaruthiManufacturer.name = Name;
        MaruthiManufacturer.supplierForTyres = Tyres;
        MaruthiManufacturer.supplierForBody = Body;
        MaruthiManufacturer.manufacturerAddress = Ad;
    }

    function setVedanthaSupplier(string memory Name, address Ad) public {
        carBodySupplier.name = Name;
        carBodySupplier.carBodySupplierAddress = Ad;
    }

    function setMrfSupplier(string memory Name, string memory SuppliesTo, address Ad) public {
        MrfCarTyreSupplier.name = Name;
        MrfCarTyreSupplier.suppliesTo = SuppliesTo;
        MrfCarTyreSupplier.carTyreSupplierAddress = Ad;
    }

    function setCeatSupplier(string memory Name, string memory SuppliesTo, address Ad) public {
        CeatCarTyreSupplier.name = Name;
        CeatCarTyreSupplier.suppliesTo = SuppliesTo;
        CeatCarTyreSupplier.carTyreSupplierAddress = Ad;
    }

// Setting supplier limits for tyres------------------------------------------------------
    
    
    function setCarTyreSupplierLimit_MRF(uint limit) public {
        CarTyreSupplierLimit_MRF = limit ;
    }

    function viewTyreSupplierLimit() public view returns(uint){
        return CarTyreSupplierLimit_MRF;
    }

    function setCarTyreSupplierLimit_CEAT(uint limit) public {
        CarTyreSupplierLimit_CEAT = limit ;
    }

    function viewCarTyreSupplierLimit_CEAT() public view returns(uint){
        return CarTyreSupplierLimit_CEAT;
    }

    
// car body counting------------------------------------------------------------

    function numberOfCarBodiesNeeded_TATA() public view returns (uint){
        return CarTyreSupplierLimit_MRF/4; 
    } 

    function numberOfCarBodiesNeeded_MARUTHI() public view returns (uint){
        return CarTyreSupplierLimit_CEAT/4; 
    }

    /*function carBodySupplyLimit_VEDANTHA(uint carBodies) public {
        CarBodySupplierLimit_VEDANTHA = carBodies;
    } 

    function viewCarBodySupplyLimit_VEDANTHA() public view returns(uint){
        return CarBodySupplierLimit_VEDANTHA;
    }*/
}

//Bidding contract------------------------------------------------------------------

contract BidForCarBodies is MyContract{

    enum BidResult{ WON, LOST}
    BidResult tataResult;
    BidResult maruthiResult;

    struct Bid{
        uint quantity;
        uint amount;
    }

    uint carBodiesWonInAuction_TATA = 0;
    uint carBodiesWonInAuction_MARUTHI = 0;

//placing for bids


    Bid CarBodySupplierBid_VEDANTHA;
    Bid CarTyreSupplierBid_MRF;
    Bid CarTyreSupplierBid_CEAT;
    Bid CarBodyManufacturerBid_TATA;
    Bid CarBodyManufacturerBid_MARUTHI;
    Bid CarTyreManufacturerBid_TATA;
    Bid CarTyreManufacturerBid_MARUTHI;


//Supplier Bid Functions --------------------- Input ---------------------- And Outputs -----------------------
    function carBodySupplierBid (uint quantity,uint amount) public {
        CarBodySupplierBid_VEDANTHA =Bid(quantity,amount);
    }

    function viewCarBodySupplierBid () public view returns(Bid memory){
        return CarBodySupplierBid_VEDANTHA;
    }


    function carTyreSupplierBid_MRF (uint amount) public {
        CarTyreSupplierBid_MRF =Bid(CarTyreSupplierLimit_MRF,amount);
    }

    function viewCarTyreSupplierBid_MRF () public view returns(Bid memory){
        return CarTyreSupplierBid_MRF;
    }


    function carTyreSupplierBid_CEAT (uint amount) public {
        CarTyreSupplierBid_CEAT =Bid(CarTyreSupplierLimit_CEAT,amount);
    }

    function viewCarTyreSupplierBid_CEAT () public view returns(Bid memory){
        return CarTyreSupplierBid_CEAT;
    }


//Manufacturer Bid Functions --------------------- Input ---------------------- And Outputs -----------------------


    function carBodyManufacturerBid_TATA (uint quantity,uint amount) public {
        CarBodyManufacturerBid_TATA =Bid(quantity,amount);
    }

    function viewCarBodyManufacturerBid_TATA () public view returns(Bid memory){
        return CarBodyManufacturerBid_TATA;
    }


    function carBodyManufacturerBid_MARUTHI (uint quantity,uint amount) public {
        CarBodyManufacturerBid_MARUTHI = Bid(quantity,amount);
    }

    function viewCarBodyManufacturerBid_MARUTHI () public view returns(Bid memory){
        return CarBodyManufacturerBid_MARUTHI;
    }


   //Tyre Manufacturer Bid Functions --------------------- Input ---------------------- And Outputs -----------------------

    function carTyreManufacturerBid_TATA(uint256 quantity, uint256 amount)
        public
    {
        CarTyreManufacturerBid_TATA = Bid(quantity, amount);
    }

    function viewCarTyreManufacturerBid_TATA()
        public
        view
        returns (Bid memory)
    {
        return CarTyreManufacturerBid_TATA;
    }

    function carTyreManufacturerBid_MARUTHI(uint256 quantity, uint256 amount)
        public
    {
        CarTyreManufacturerBid_MARUTHI = Bid(quantity, amount);
    }

    function viewCarTyreManufacturerBid_MARUTHI()
        public
        view
        returns (Bid memory)
    {
        return CarTyreManufacturerBid_MARUTHI;
    }


//Bidding Function ---------------------------------------------
    function biddingForCarBody() public  {
        
        uint carBodiesLeftForSupplier_VEDANTHA;

        if(CarBodyManufacturerBid_TATA.quantity > CarBodySupplierBid_VEDANTHA.quantity && CarBodyManufacturerBid_MARUTHI.quantity > CarBodySupplierBid_VEDANTHA.quantity){
            tataResult = BidResult.LOST;
            maruthiResult = BidResult.LOST;
            carBodiesWonInAuction_TATA = 0;
            carBodiesWonInAuction_MARUTHI = 0;
        }
        else{
            if(CarBodyManufacturerBid_MARUTHI.quantity > CarBodySupplierBid_VEDANTHA.quantity && CarBodyManufacturerBid_TATA.quantity <= CarBodySupplierBid_VEDANTHA.quantity){
                tataResult = BidResult.WON;
                maruthiResult = BidResult.LOST;
                carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA.quantity;
                carBodiesWonInAuction_MARUTHI = 0;
            }
        
            else if (CarBodyManufacturerBid_MARUTHI.quantity <= CarBodySupplierBid_VEDANTHA.quantity && CarBodyManufacturerBid_TATA.quantity > CarBodySupplierBid_VEDANTHA.quantity){
                tataResult = BidResult.LOST;
                maruthiResult = BidResult.WON;
                carBodiesWonInAuction_TATA = 0;
                carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI.quantity;
            }
        
            else if (CarBodyManufacturerBid_MARUTHI.quantity < CarBodySupplierBid_VEDANTHA.quantity && CarBodyManufacturerBid_TATA.quantity < CarBodySupplierBid_VEDANTHA.quantity){
            
                if(CarBodyManufacturerBid_MARUTHI.quantity > NumberOfCarBodiesNeeded_MARUTHI && CarBodyManufacturerBid_TATA.quantity > NumberOfCarBodiesNeeded_TATA){
 //check the algorithm for this-------------------------------------------------------------------------------------------------------               
                    if(CarBodyManufacturerBid_MARUTHI.quantity + CarBodyManufacturerBid_TATA.quantity <= CarBodySupplierBid_VEDANTHA.quantity){
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.WON;
                        carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA.quantity;
                        carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI.quantity;
                    }
                    else if(NumberOfCarBodiesNeeded_MARUTHI +  NumberOfCarBodiesNeeded_TATA <= CarBodySupplierBid_VEDANTHA.quantity){
                            tataResult = BidResult.WON;
                            maruthiResult = BidResult.WON;
                            carBodiesWonInAuction_TATA = NumberOfCarBodiesNeeded_TATA;
                            carBodiesWonInAuction_MARUTHI = NumberOfCarBodiesNeeded_MARUTHI;
                            
                            carBodiesLeftForSupplier_VEDANTHA = CarBodySupplierBid_VEDANTHA.quantity - NumberOfCarBodiesNeeded_TATA - NumberOfCarBodiesNeeded_MARUTHI;
                            
                            if (carBodiesLeftForSupplier_VEDANTHA != 0){
                                
                                if(CarBodyManufacturerBid_MARUTHI.amount > CarBodyManufacturerBid_TATA.quantity){
                                    
                                    carBodiesWonInAuction_MARUTHI += carBodiesLeftForSupplier_VEDANTHA;
                                }
                                else{
                                    carBodiesWonInAuction_TATA += carBodiesLeftForSupplier_VEDANTHA;
                                }
                            }
                            else{
                            tataResult = BidResult.WON;
                            maruthiResult = BidResult.LOST;
                            carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA.quantity;
                            carBodiesWonInAuction_MARUTHI = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_TATA.quantity;
                            }
                        }
                    }
                    else{
                        if(CarBodyManufacturerBid_MARUTHI.amount > CarBodyManufacturerBid_TATA.quantity){
                        tataResult = BidResult.LOST;
                        maruthiResult = BidResult.WON;
                        carBodiesWonInAuction_TATA = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_MARUTHI.quantity;
                        carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI.quantity;
                        }
                        else{
                        tataResult = BidResult.WON;
                        maruthiResult = BidResult.LOST;
                        carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA.quantity;
                        carBodiesWonInAuction_MARUTHI = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_TATA.quantity;
                        }
                    }
                }
                else if (CarBodyManufacturerBid_MARUTHI.quantity > NumberOfCarBodiesNeeded_MARUTHI && NumberOfCarBodiesNeeded_TATA == NumberOfCarBodiesNeeded_TATA){
                    tataResult = BidResult.WON;
                    maruthiResult = BidResult.LOST;
                    carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA.quantity;
                    carBodiesWonInAuction_MARUTHI = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_TATA.quantity;
                }
                else if (CarBodyManufacturerBid_MARUTHI.quantity == NumberOfCarBodiesNeeded_MARUTHI && CarBodyManufacturerBid_TATA.quantity > NumberOfCarBodiesNeeded_TATA){
                    tataResult = BidResult.LOST;
                    maruthiResult = BidResult.WON;
                    carBodiesWonInAuction_TATA = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_MARUTHI.quantity;
                    carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI.quantity;
                }
                else if ((CarBodyManufacturerBid_MARUTHI.quantity == NumberOfCarBodiesNeeded_MARUTHI && CarBodyManufacturerBid_TATA.quantity == NumberOfCarBodiesNeeded_TATA) || 
                        (CarBodyManufacturerBid_MARUTHI.quantity < NumberOfCarBodiesNeeded_MARUTHI && CarBodyManufacturerBid_TATA.quantity == NumberOfCarBodiesNeeded_TATA) ||
                        (CarBodyManufacturerBid_MARUTHI.quantity == NumberOfCarBodiesNeeded_MARUTHI && CarBodyManufacturerBid_TATA.quantity < NumberOfCarBodiesNeeded_TATA) ||
                        (CarBodyManufacturerBid_MARUTHI.quantity < NumberOfCarBodiesNeeded_MARUTHI && CarBodyManufacturerBid_TATA.quantity < NumberOfCarBodiesNeeded_TATA))
                        {
                            if(CarBodyManufacturerBid_MARUTHI.amount > CarBodyManufacturerBid_TATA.quantity){
                                tataResult = BidResult.LOST;
                                maruthiResult = BidResult.WON;
                                carBodiesWonInAuction_TATA = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_MARUTHI.quantity;
                                carBodiesWonInAuction_MARUTHI = CarBodyManufacturerBid_MARUTHI.quantity;
                            }
                            else{
                                tataResult = BidResult.WON;
                                maruthiResult = BidResult.LOST;
                                carBodiesWonInAuction_TATA = CarBodyManufacturerBid_TATA.quantity;
                                carBodiesWonInAuction_MARUTHI = CarBodySupplierBid_VEDANTHA.quantity - CarBodyManufacturerBid_TATA.quantity;
                            }    
                        }
                }
            }
          function viewBidResult() public view returns(BidResult,BidResult){
        return (tataResult,maruthiResult);
    }
    }
   

