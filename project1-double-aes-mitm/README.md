# Project 1 — Double AES (ECB) Key Recovery Lab

This repository contains a cryptography lab **designed as a teaching assistant**
for an Information Security course.

The goal of this project is to demonstrate:
1. **Why ECB mode leaks structure** (via frequency/pattern leakage in images), and
2. **Why Double AES is vulnerable to meet-in-the-middle (MITM) attacks**.

This is a *problem-design repository*, not a solution repository.

---

## Background

A message is encrypted using **Double AES-128 in ECB mode**:

C = AES_ECB(K2, AES_ECB(K1, P))

where a 256-bit key K = K1 || K2 is split into two AES-128 keys.

ECB mode preserves structural patterns, which can leak partial information
about the encryption key when applied to structured data such as images.

---

## Given Artifacts

- `src/enc.py`  
  Reference encryption code implementing Double AES-128 (ECB).

- `assets/clue.png`  
  An ECB-encrypted image that visually leaks a **partial key hint**.

- A known plaintext–ciphertext pair (P1, C1)  
- A target ciphertext C2 to be decrypted

(Plaintext/ciphertext values are described in the assignment text.)

---

## Tasks

### Task 1 — Key Hint Extraction
Recover a partial key hint by analyzing structural leakage
in the ECB-encrypted image.

File:
- `src/tasks/keyhint_extractor.py`

---

### Task 2 — Meet-in-the-Middle Attack
Using the key hint, perform a meet-in-the-middle attack on Double AES
to recover the full key K = K1 || K2.

File:
- `src/tasks/recover_key_mitm.py`

---

### Task 3 — Decrypt Target Ciphertext
Use the recovered key to decrypt C2 and obtain the plaintext.

File:
- `src/tasks/decrypt_c2.py`

---

## Learning Objectives

- Understand ECB mode leakage beyond textbook examples
- Apply meet-in-the-middle attacks in a realistic cryptographic setting
- Reason about key recovery feasibility and computational trade-offs

---

## Solution Policy

To preserve academic integrity and allow reuse of this lab,
**complete solution code is intentionally not included**.

This repository focuses on **problem design and learning objectives**.

---

## Disclaimer

This project is for **educational purposes only** and demonstrates
cryptographic weaknesses in insecure constructions.
