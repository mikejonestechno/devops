Given "the meetup api service is available" {
    # code here to ensure the api service is running on the server?
}

When "I request the profile id (?<id>\d+)" {
    param($id)
    $uri = "https://api.meetup.com/members/$id"
    $resp = Invoke-RestMethod -Uri $uri -Method Get
}
Then "the returned JSON response should return the bio like '(?<bio>.*)'" {
    param($bio)
    $($resp).bio | Should -BeLike "*$bio*"
}

When "I update profile id (?<id>.*)" {
    param($id)
}

And "set the bio to '(?<newBio>.*)'" {
    param($newBio)
    $uriParams = $uriParams + "&bio=$newBio" 
    $uri = "https://api.meetup.com/members/$($id)?$($uriParams)"
	$body = '' # Meetup API submits data via uri params instead of body 
	$headers = '' # Meetup API accepts API key via uri params instead of header token/oauth
    try {
        $resp = Invoke-RestMethod -Uri $uri -Method Patch -Body $body -Headers $headers -ContentType 'application/json'  -ErrorVariable HttpError -ErrorAction SilentlyContinue 
        $responseCode = 200
    } catch {  # catch errors so that we can test invalid data returns a 400 error response
			If ($HttpError.ErrorRecord) {
					$responseCode = $HttpError.ErrorRecord.Exception.Response.StatusCode.value__
                    Write-Warning "$uri returned status code $responseCode"
			}
	}
}

Then "the returned JSON response should return 400 bad request" {
    $responseCode | Should -Be 400
}

Given "I have authenticated with the API" {
$uriParams = 'key=5551234123412341234123412341234'
}

Then "the returned JSON response should return OK" {
    Write-Host $uri
    $responseCode | Should -Be 200
}