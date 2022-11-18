//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PetPark {

    address owner;
    //the contract has three functions
    //add, borrow, giveBackAnimal

    enum AnimalType{None, Fish, Cat, Dog, Rabbit, Parrot}
    enum Gender{Male, Female}
    uint Age;


    mapping(AnimalType => uint) public typeToCount;
    mapping(address => AnimalType) public personToAnimal;

    event Added(AnimalType _animalType, uint _count);
    event Borrowed(AnimalType _animalType);
    event Returned(AnimalType _animalType);

    function addAnimal(AnimalType _animalType, uint _count) public {
        // Update the value at this address
        typeToCount[_animalType] = typeToCount[_animalType] + _count;
        emit Added(_animalType, typeToCount[_animalType]);
    }

    function borrowAnimal(AnimalType _animalType, uint _age, Gender _gender) public{

        if(_gender == Gender(0)) {
            require(_animalType == AnimalType(1) || _animalType == AnimalType(4), "Men can only borrow Dog and Fish");
        } else if(_gender == Gender(1) && _age < 40) {
            require(_animalType != AnimalType(2), "Women under 40 cannot borrow Cat");
        }

        if(personToAnimal[msg.sender] == AnimalType(0)) {
            personToAnimal[msg.sender] = AnimalType(_animalType);
            typeToCount[_animalType] = typeToCount[_animalType] - 1;
            emit Borrowed(_animalType);
        } else {
            giveBackAnimal(_animalType);
            personToAnimal[msg.sender] = AnimalType(_animalType);
            typeToCount[_animalType] = typeToCount[_animalType] - 1;

        }
    }

    function giveBackAnimal(AnimalType _animalType) public{
        require(personToAnimal[msg.sender] != AnimalType(0), "You have not borrowed");

        personToAnimal[msg.sender] = AnimalType(0);
        typeToCount[_animalType] = typeToCount[_animalType] + 1;
        emit Returned(_animalType);

    }



    
}