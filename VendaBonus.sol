// SPDX-License-Identifier: MIT
//0xDA0bab807633f07f013f94DD0E6A4F96F8742B53

pragma solidity ^0.8.15;

contract VendaBonus {

    string public nomeVendedor;
    uint256 public bonus;

function setBonus(uint256 _bonus)public {
    bonus = _bonus;
}

function setNomeVendedor(string memory _nome) public {
    nomeVendedor = _nome;
}


    // constructor(uint256 _bonus , string memory _nomeVendedor){
    //     bonus = _bonus;
    //     nomeVendedor = _nomeVendedor;

    // }


    function calculaBonus(uint256 _venda) public view  returns (uint256){
        return  (_venda * bonus) / 100 ;
    }
}
