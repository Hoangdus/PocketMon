//
//  DownloadFile.swift
//  PocketMon
//
//  Created by HoangDus on 19/06/2025.
//

import Foundation

func downloadFile(from url: URL, saveLocation: URL, fileName: String, completion: @escaping (URL?, Error?) -> Void) {
	let destinationURL = saveLocation.appendingPathComponent(fileName)
	
	let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
		if let error = error {
			completion(nil, error)
			return
		}
		
		guard let localURL = localURL else {
			completion(nil, NSError(domain: "DownloadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No local URL"]))
			return
		}
		
		do {
			// Remove existing file if it exists
			if FileManager.default.fileExists(atPath: destinationURL.path) {
				try FileManager.default.removeItem(at: destinationURL)
			}
				
			try FileManager.default.moveItem(at: localURL, to: destinationURL)
			completion(destinationURL, nil)
		} catch {
			completion(nil, error)
		}
	}
	task.resume()
}
