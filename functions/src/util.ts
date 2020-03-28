export const getOTP = function (): number {
    const otpGenerator = require('otp-generator')
    const otp = otpGenerator.generate(4, {
        alphabets: false,
        upperCase: false,
        specialChars: false,
    });
    return otp;
}