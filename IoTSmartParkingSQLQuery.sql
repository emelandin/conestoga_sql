CREATE TABLE User_Information_TBL (
    User_Id					int NOT NULL PRIMARY KEY,
	First_Name				nvarchar(50) NOT NULL,
    Middle_Name				nvarchar(50),
    Last_Name				nvarchar(50) NOT NULL,
    Is_Verified				bit NOT NULL,
	Contact_Num				nvarchar(10) NOT NULL
);

CREATE TABLE Phone_Verification_TBL (
    Verify_Id				int NOT NULL PRIMARY KEY,
    API_Phone_Code			nvarchar(10) NOT NULL UNIQUE,   
    User_Id					int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL UNIQUE
);

CREATE TABLE User_Credentials_TBL (
    User_Login_Id			int NOT NULL PRIMARY KEY,
    Email_Id				nvarchar(100) NOT NULL UNIQUE,
	Password				nvarchar(50) NOT NULL,   
    User_Id					int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL UNIQUE
);

CREATE TABLE Address_Type_TBL (
    Address_Type_Id			int NOT NULL PRIMARY KEY,
    Type_Of_Address			varchar(20) NOT NULL UNIQUE,
);

CREATE TABLE User_Address_TBL (
    User_Adreess_Id			int NOT NULL PRIMARY KEY,
    Apartment_Unit_Num		nvarchar(20) NOT NULL,
	City					nvarchar(20) NOT NULL,
    Street					nvarchar(30) NOT NULL,
	ZipCode					nvarchar(10) NOT NULL,
    State_Province			varchar(30) NOT NULL,
	Address_Type_Id			int FOREIGN KEY REFERENCES Address_Type_TBL(Address_Type_Id) NOT NULL,
	User_Login_Id			int FOREIGN KEY REFERENCES User_Credentials_TBL(User_Login_Id),
	User_Id					int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL
);

CREATE TABLE Vehicle_TBL (
	License_Plate_ID		nvarchar(10) NOT NULL PRIMARY KEY,
	Make					nvarchar(20) NOT NULL,
	Model					nvarchar(20) NOT NULL,
	User_Login_Id			int FOREIGN KEY REFERENCES User_Credentials_TBL(User_Login_Id),
	User_Id					int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL
);

CREATE TABLE Booking_Type_TBL (
    Booking_Type_Id			int NOT NULL PRIMARY KEY,
    Type_Of_Booking			nvarchar(50) NOT NULL,
	Description_Of_Booking	nvarchar(50) NOT NULL,
	Price					smallmoney NOT NULL,
);

CREATE TABLE Booking_Details_TBL (
    Booking_Detail_Id		int NOT NULL PRIMARY KEY,
	Booking_Time			TIMESTAMP NOT NULL,
	Booking_Type_Id			int FOREIGN KEY REFERENCES Booking_Type_TBL(Booking_Type_Id) NOT NULL,
    User_Login_Id			int FOREIGN KEY REFERENCES User_Credentials_TBL(User_Login_Id),
	User_Id					int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL
);

CREATE TABLE QR_Code_TBL (
	Ticket_Id_QRcode		int NOT NULL PRIMARY KEY,
	Booking_Detail_Id		int FOREIGN KEY REFERENCES Booking_Details_TBL(Booking_Detail_Id) UNIQUE NOT NULL
);

CREATE TABLE Card_Type_TBL (
    Card_Type_Id			int NOT NULL PRIMARY KEY,
    Card_Type_Description	nvarchar(20) NOT NULL UNIQUE,
);

CREATE TABLE Card_Details_TBL (
    Card_Id					int NOT NULL PRIMARY KEY,
	Card_Num				nvarchar(50) NOT NULL,
    Expiry_Month			int NOT NULL,
    Expiry_Year				int NOT NULL,
	CVV						int NOT NULL,
    Card_Holder_First_Name	nvarchar(50) NOT NULL,
	Card_Holder_Last_Name	nvarchar(50) NOT NULL,
	Card_Type_Id			int FOREIGN KEY REFERENCES Card_Type_TBL(Card_Type_Id) NOT NULL,
	User_Login_Id			int FOREIGN KEY REFERENCES User_Credentials_TBL(User_Login_Id) NOT NULL
)


CREATE TABLE Card_Validation_TBL (
    Card_Valid_Transaction_Id	int NOT NULL PRIMARY KEY,
    Validation_Amount 			int NOT NULL,
	Transaction_Type			nvarchar(10) NOT NULL,
	Card_Id						int FOREIGN KEY REFERENCES Card_Details_TBL(Card_Id) NOT NULL
);


CREATE TABLE Notification_Type_TBL (
    Notification_Type_Id		int NOT NULL PRIMARY KEY,
	Notification_Message_Key	nvarchar(10) NOT NULL,
);


CREATE TABLE Notification_Transaction_Record_TBL (
    Notification_Transaction_Id int NOT NULL PRIMARY KEY,
    User_Id						int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL,
	Notification_Type_Id		int FOREIGN KEY REFERENCES Notification_Type_TBL(Notification_Type_Id) NOT NULL,
	Notification_Timestamp		TIMESTAMP NOT NULL
);


CREATE TABLE Camera_TBL (
    Camera_Id       		int NOT NULL PRIMARY KEY,
	Camera_Location			nvarchar(50) NOT NULL,
);


CREATE TABLE Sensor_TBL (
    Sensor_Id       		int NOT NULL PRIMARY KEY,
	Sensor_Grid_Location    nvarchar(20) NOT NULL,
	Sensor_Status			nvarchar(20) NOT NULL,
);

CREATE TABLE Barrier_Gate_TBL (
    Gate_Id		        int NOT NULL PRIMARY KEY,
	Camera_Id		    int FOREIGN KEY REFERENCES Camera_TBL(Camera_Id) NOT NULL,
    Sensor_Id 			int FOREIGN KEY REFERENCES Sensor_TBL(Sensor_Id) NOT NULL,
);

CREATE TABLE Images_TBL (
    Image_Id       		int NOT NULL PRIMARY KEY,
	Image_Path          nvarchar(100) NOT NULL,
	Image_TimeStamp     TIMESTAMP NOT NULL,
	Camera_Id		    int FOREIGN KEY REFERENCES Camera_TBL(Camera_Id) NOT NULL,
);



CREATE TABLE Arrival_Transaction_TBL (
    Arrival_Transaction_Id		int NOT NULL PRIMARY KEY,
	Parking_Start_Time			timestamp NOT NULL,
	Ticket_Id_QRcode			int FOREIGN KEY REFERENCES QR_Code_TBL(Ticket_Id_QRcode) NOT NULL,
	Gate_Id         			int FOREIGN KEY REFERENCES Barrier_Gate_TBL(Gate_Id) NOT NULL,
    Image_Id 		    		int FOREIGN KEY REFERENCES Images_TBL(Image_Id) NOT NULL,
);

CREATE TABLE Departure_Transaction_TBL (
    Departure_Transaction_Id	int NOT NULL PRIMARY KEY,
	Parking_Start_Time			timestamp NOT NULL,
	Ticket_Id_QRcode			int FOREIGN KEY REFERENCES QR_Code_TBL(Ticket_Id_QRcode) NOT NULL,
	Gate_Id         			int FOREIGN KEY REFERENCES Barrier_Gate_TBL(Gate_Id) NOT NULL,
    Image_Id 		    		int FOREIGN KEY REFERENCES Images_TBL(Image_Id) NOT NULL,
);


CREATE TABLE Parking_Summary_TBL (
	Parking_Summary_Id			int NOT NULL PRIMARY KEY,
	Trip_Total_Charges			Money NOT NULL,
	Trip_Total_Time				int NOT NULL,
	Ticket_Id_QRcode			int FOREIGN KEY REFERENCES QR_Code_TBL (Ticket_Id_QRcode) UNIQUE NOT NULL ,
	Arrival_Transaction_Id		int FOREIGN KEY REFERENCES Arrival_Transaction_TBL (Arrival_Transaction_Id) UNIQUE NOT NULL,
	Departure_Transaction_Id	int FOREIGN KEY REFERENCES Departure_Transaction_TBL (Departure_Transaction_Id) UNIQUE NOT NULL,
	Booking_Type_Id				int FOREIGN KEY REFERENCES Booking_Type_TBL (Booking_Type_Id) NOT NULL,
    User_Login_Id				int FOREIGN KEY REFERENCES User_Credentials_TBL(User_Login_Id),
	User_Id						int FOREIGN KEY REFERENCES User_Information_TBL(User_Id) NOT NULL
);


CREATE TABLE Payment_Transaction_TBL (
	Payment_Transaction_Id		int NOT NULL PRIMARY KEY,
	Parking_Summary_Id			int FOREIGN KEY REFERENCES Parking_Summary_TBL (Parking_Summary_Id) UNIQUE NOT NULL,
	Card_Id						int FOREIGN KEY REFERENCES Card_Details_TBL (Card_Id) NOT NULL,  
	Payment_TimeStamp			TIMESTAMP NOT NULL
);
	
