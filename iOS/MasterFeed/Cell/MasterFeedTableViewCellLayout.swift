//
//  MasterTableViewCellLayout.swift
//  NetNewsWire
//
//  Created by Brent Simmons on 11/24/17.
//  Copyright © 2017 Ranchero Software. All rights reserved.
//

import UIKit
import RSCore

struct MasterFeedTableViewCellLayout {

	private static let indent = CGFloat(integerLiteral: 14)
	private static let editingControlIndent = CGFloat(integerLiteral: 40)
	private static let imageSize = CGSize(width: 16, height: 16)
	private static let marginLeft = CGFloat(integerLiteral: 8)
	private static let imageMarginRight = CGFloat(integerLiteral: 8)
	private static let unreadCountMarginLeft = CGFloat(integerLiteral: 8)
	private static let unreadCountMarginRight = CGFloat(integerLiteral: 0)
	private static let disclosureButtonSize = CGSize(width: 44, height: 44)
	
	let faviconRect: CGRect
	let titleRect: CGRect
	let unreadCountRect: CGRect
	let disclosureButtonRect: CGRect
	
	let height: CGFloat
	
	init(cellWidth: CGFloat, insets: UIEdgeInsets, shouldShowImage: Bool, label: UILabel, unreadCountView: MasterFeedUnreadCountView, showingEditingControl: Bool, indent: Bool, shouldShowDisclosure: Bool) {

		var initialIndent = MasterFeedTableViewCellLayout.marginLeft + insets.left
		if indent {
			initialIndent += MasterFeedTableViewCellLayout.indent
		}
		if showingEditingControl {
			initialIndent += MasterFeedTableViewCellLayout.editingControlIndent
		}
		
		let bounds = CGRect(x: initialIndent, y: 0.0, width: floor(cellWidth - initialIndent - insets.right), height: 0.0)
		
		// Favicon
		var rFavicon = CGRect.zero
		if shouldShowImage {
			rFavicon = CGRect(x: bounds.origin.x, y: 0.0, width: MasterFeedTableViewCellLayout.imageSize.width, height: MasterFeedTableViewCellLayout.imageSize.height)
		}

		// Unread Count
		let unreadCountSize = unreadCountView.intrinsicContentSize
		let unreadCountIsHidden = unreadCountView.unreadCount < 1

		var rUnread = CGRect.zero
		if !unreadCountIsHidden {
			rUnread.size = unreadCountSize
			rUnread.origin.x = bounds.maxX -
				(unreadCountSize.width + MasterFeedTableViewCellLayout.unreadCountMarginRight + MasterFeedTableViewCellLayout.disclosureButtonSize.width)
		}
		
		// Disclosure Button
		var rDisclosure = CGRect.zero
		if shouldShowDisclosure {
			rDisclosure.size = MasterFeedTableViewCellLayout.disclosureButtonSize
			rDisclosure.origin.x = bounds.maxX - MasterFeedTableViewCellLayout.disclosureButtonSize.width
		}

		// Title
		let labelWidth = bounds.width - (rFavicon.width + MasterFeedTableViewCellLayout.imageMarginRight + MasterFeedTableViewCellLayout.unreadCountMarginLeft + rUnread.width + MasterFeedTableViewCellLayout.unreadCountMarginRight + rDisclosure.width)
		let labelSizeInfo = MultilineUILabelSizer.size(for: label.text ?? "", font: label.font, numberOfLines: 0, width: Int(floor(labelWidth)))
		
		var rLabel = CGRect(x: 0.0, y: 0.0, width: labelSizeInfo.size.width, height: labelSizeInfo.size.height)
		if shouldShowImage {
			rLabel.origin.x = rFavicon.maxX + MasterFeedTableViewCellLayout.imageMarginRight
		} else {
			rLabel.origin.x = bounds.minX
		}
		
		// Determine cell height
		let cellHeight = [rFavicon, rLabel, rUnread, rDisclosure].maxY()

		// Center in Cell
		let newBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: cellHeight)

		if shouldShowImage {
			rFavicon = MasterFeedTableViewCellLayout.centerVertically(rFavicon, newBounds)
		}
		
		if !unreadCountIsHidden {
			rUnread = MasterFeedTableViewCellLayout.centerVertically(rUnread, newBounds)
		}

		if shouldShowDisclosure {
			rDisclosure = MasterFeedTableViewCellLayout.centerVertically(rDisclosure, newBounds)
		}

		rLabel = MasterFeedTableViewCellLayout.centerVertically(rLabel, newBounds)

		//  Assign the properties
		self.height = cellHeight
		self.faviconRect = rFavicon
		self.unreadCountRect = rUnread
		self.disclosureButtonRect = rDisclosure
		self.titleRect = rLabel
		
	}
	
	// Ideally this will be implemented in RSCore (see RSGeometry)
	static func centerVertically(_ originalRect: CGRect, _ containerRect: CGRect) -> CGRect {
		var result = originalRect
		result.origin.y = containerRect.midY - (result.height / 2.0)
		result = result.integral
		result.size = originalRect.size
		return result
	}
	
}