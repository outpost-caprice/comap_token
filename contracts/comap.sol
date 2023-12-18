// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";
import "@thirdweb-dev/contracts/extension/Permissions.sol";

// Comapコントラクトの定義
contract Comap is ERC20Base {
    // プライベート変数: 承認チェックが必要かどうか
    bool private _isCheckRequired;
    
    // 承認を許可されたアドレスのマッピング
    mapping(address => bool) private _allowedApproveAddresses;

    // コンストラクタ
    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol
    )
    ERC20Base(
        _defaultAdmin,
        _name,
        _symbol
    )
    {
        // 承認チェックをデフォルトで有効に設定
        _isCheckRequired = true;
    }

    // 承認チェックの有効/無効を設定する関数
    function setApproveCheck(bool _status) public {
        _isCheckRequired = _status;
    }

    // 特定のアドレスを承認許可リストに追加する関数
    function allowAddressForApprove(address _address) public {
        _allowedApproveAddresses[_address] = true;
    }

    // 特定のアドレスを承認許可リストから削除する関数
    function disallowAddressForApprove(address _address) public {
        _allowedApproveAddresses[_address] = false;
    }

    // 承認機能のオーバーライド
    function approve(address spender, uint256 amount) public override returns (bool) {
        // 承認チェックが必要な場合、送信者が許可リストに含まれているか確認
        if (_isCheckRequired) {
            require(_allowedApproveAddresses[msg.sender], "do not allow approve");
        }
        return super.approve(spender, amount);
    }
}