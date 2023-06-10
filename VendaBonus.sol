// SPDX-License-Identifier: MIT
//0x369315fBaa62C7b2CB68a901d047f6CE1033EA71

pragma solidity ^0.8.15;

contract VendaBonus {

    string public nomeVendedor;
    uint256 public bonus;

function setBonus(uint256 _bonus)public {
    bonus = _bonus;
}

function setNomeVendedor(string memory _nomeVendedor) public {
    nomeVendedor = _nomeVendedor;
}


    // constructor(uint256 _bonus , string memory _nomeVendedor){
    //     bonus = _bonus;
    //     nomeVendedor = _nomeVendedor;

    // }


    function calculaBonus(uint256 _venda) public view  returns (uint256){
        return  (_venda * bonus) / 100 ;
    }
}
