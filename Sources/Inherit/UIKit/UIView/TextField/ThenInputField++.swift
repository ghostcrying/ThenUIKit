//
//  ThenInputField++.swift
//  ThenUIKit
//
//  Created by ghost on 2023/2/22.
//

import UIKit

extension ThenInputField: UICollectionViewDataSource {
        
    func reloadCells() {
        
        self.collectionView.reloadData()
        
        let length = cellTexts.count
        if self.codelength == length {
            self.collectionView.scrollToItem(at: IndexPath(row: length - 1, section: 0), at: .right, animated: true)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(row: length, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.codelength
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThenInputFieldCell.Identifier, for: indexPath) as! ThenInputFieldCell
        cell.isShowCursor = isShowCursor
        
        let config = cellConfigurations[indexPath.row]
        // index
        config.currentIndex = indexPath.row
        // place
        if let text = placeholderText, text.count > indexPath.row {
            config.placeholderText = text[safe: indexPath.row..<(indexPath.row+1)]
        }
        // origin
        if indexPath.row < cellTexts.count {
            config.originText = cellTexts[indexPath.row]
        } else {
            config.originText = ""
        }
        // set
        cell.configuration = config
        //
        if isNeedBeginEdit {
            cell.isEditSelected = indexPath.row == cellTexts.count
        } else {
            cell.isEditSelected = false
        }
            
        return cell
    }

}

extension ThenInputField: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
}

extension ThenInputField: UITextFieldDelegate {
    
    @objc func textFieldEditChange() {
        self.textFieldDidChange(textField, isManual: false)
    }
    
    /// isTarget: textfield target action trigger
    func textFieldDidChange(_ textField: UITextField, isManual: Bool) {
        // replace space character
        let text = textField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        // filter
        var str = text.inputFieldFilter(regex: self.inputRegex, inputType)
        // closure
        if let closure = self.textProcessClosure {
            str = closure(str)
        }
        if str.count >= codelength {
            str = str[safe: 0..<codelength] ?? ""
            self.endedEdit()
        }
        //
        self.textField.text = str
        
        let length = str.count
        
        let reloadConfig = { [weak self] in
            self?.reloadCells()
            self?.oldlength = str.count
            self?.textDidChangeClosure?(str, length == self?.codelength)
        }
        // judge delete/append
        switch length {
        case 0..<oldlength:
            self.updateSingleSecurity(isShow: false, cellTexts.count - 1)
            self.cellTexts.removeLast()
            reloadConfig()
        case (oldlength + 1)...:
            if !cellTexts.isEmpty {
                self.replaceCellTexts(index: cellTexts.count - 1, islatest: false)
            }
            self.cellTexts = str.map { String($0) }
            if isSecurity {
                if isManual {
                    self.delaySecurityAllProcess()
                } else {
                    self.delaySecuritylatestProcess()
                }
            }
            reloadConfig()
        default:
            break
        }
    }
        
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    
        self.isNeedBeginEdit = true
        if self.isClearInBeginEditing && self.text?.count == self.codelength {
            self.clear(true)
        }
        //
        self.textEditStatusClosure?(.begin)
        //
        self.reloadCells()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.isNeedBeginEdit = false
        self.textEditStatusClosure?(.end)
        self.reloadCells()
    }
}


//MARK: - Filter
fileprivate extension String {
    
    ///
    func inputFieldFilter(regex: String?, _ type: ThenInputFieldInputType) -> String {
        switch type {
        case .number:
            let regular = try? NSRegularExpression(pattern: "[^\\d]")
            let result = regular?.stringByReplacingMatches(in: self, range: NSRange(location: 0, length: count), withTemplate: "")
            return result ?? self
        case .regex:
            if let regex = regex {
                let regular = try? NSRegularExpression(pattern: regex)
                let result = regular?.stringByReplacingMatches(in: self, range: NSRange(location: 0, length: count), withTemplate: "")
                return result ?? self
            }
        default:
            break
        }
        return self
    }
}
